import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/types.dart';
import '../theme/app_theme.dart';
import '../services/storage_service.dart';

class JourneyScreen extends StatefulWidget {
  final DhikrCategory category;
  const JourneyScreen({super.key, required this.category});

  @override
  State<JourneyScreen> createState() => _JourneyScreenState();
}

class _JourneyScreenState extends State<JourneyScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  int _count = 0;
  int _customTarget = 0;
  bool _journeyComplete = false;
  int _totalPoints = 0;
  bool _showingMini = false;

  late AnimationController _pulseCtrl;
  late AnimationController _celebrateCtrl;
  late Animation<double> _pulseAnim;
  late Animation<double> _celebrateAnim;

  @override
  void initState() {
    super.initState();
    _customTarget = widget.category.adhkar[0].count;

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _pulseAnim = Tween<double>(begin: 1.0, end: 0.88)
        .animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    _celebrateCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _celebrateAnim = CurvedAnimation(parent: _celebrateCtrl, curve: Curves.elasticOut);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _celebrateCtrl.dispose();
    super.dispose();
  }

  DhikrItem get _current => widget.category.adhkar[_currentIndex];
  int get _total => widget.category.adhkar.length;
  double get _journeyProgress =>
      (_currentIndex + (_count / _customTarget).clamp(0.0, 1.0)) / _total;

  Future<void> _onTap() async {
    if (_showingMini) return;
    HapticFeedback.lightImpact();
    _pulseCtrl.forward().then((_) => _pulseCtrl.reverse());

    final newCount = _count + 1;
    await StorageService.incrementTodayCount();
    await StorageService.incrementTotalCount();

    if (newCount >= _customTarget) {
      // اكتمل هذا الذكر
      HapticFeedback.mediumImpact();
      _totalPoints += _customTarget;
      _celebrateCtrl.forward(from: 0);
      setState(() {
        _count = _customTarget;
        _showingMini = true;
      });
    } else {
      setState(() => _count = newCount);
    }
  }

  Future<void> _goNext() async {
    if (_currentIndex >= _total - 1) {
      // انتهت الرحلة
      await StorageService.updateStreak();
      setState(() => _journeyComplete = true);
    } else {
      // الذكر التالي
      setState(() {
        _currentIndex++;
        _count = 0;
        _customTarget = widget.category.adhkar[_currentIndex].count;
        _showingMini = false;
      });
    }
  }

  void _showChangeCountDialog() {
    final ctrl = TextEditingController(text: '$_customTarget');
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        title: const Text('تغيير العداد',
            style: TextStyle(color: AppTheme.textPrimary)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: ctrl,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: AppTheme.textPrimary, fontSize: 28, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.accentGreen, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              children: [_current.count, 33, 50, 100].map((n) =>
                ActionChip(
                  label: Text('$n', style: const TextStyle(color: AppTheme.accentGreen)),
                  backgroundColor: AppTheme.accentGreen.withOpacity(0.1),
                  side: BorderSide(color: AppTheme.accentGreen.withOpacity(0.4)),
                  onPressed: () => ctrl.text = '$n',
                ),
              ).toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء', style: TextStyle(color: AppTheme.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              final val = int.tryParse(ctrl.text);
              if (val != null && val > 0) {
                setState(() {
                  _customTarget = val;
                  _count = 0;
                  _showingMini = false;
                });
              }
              Navigator.pop(context);
            },
            child: const Text('تطبيق'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_journeyComplete) {
      return _JourneyComplete(
        categoryName: widget.category.name,
        categoryIcon: widget.category.icon,
        totalPoints: _totalPoints,
        totalDhikr: _total,
        onRestart: () => setState(() {
          _currentIndex = 0;
          _count = 0;
          _customTarget = widget.category.adhkar[0].count;
          _journeyComplete = false;
          _totalPoints = 0;
          _showingMini = false;
        }),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.bgColor,
      appBar: AppBar(
        title: Text('${widget.category.icon} ${widget.category.name}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune, color: AppTheme.accentGold),
            onPressed: _showChangeCountDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // شريط تقدم الرحلة
          _ProgressBar(progress: _journeyProgress, current: _currentIndex + 1, total: _total),

          // مؤشرات الخطوات
          _Steps(total: _total, current: _currentIndex),

          // المحتوى
          Expanded(
            child: _showingMini
                ? _MiniCompletion(
                    dhikr: _current,
                    points: _customTarget,
                    celebrateAnim: _celebrateAnim,
                    isLast: _currentIndex >= _total - 1,
                    onNext: _goNext,
                  )
                : _Counter(
                    dhikr: _current,
                    count: _count,
                    target: _customTarget,
                    pulseAnim: _pulseAnim,
                    onTap: _onTap,
                    index: _currentIndex,
                    total: _total,
                  ),
          ),
        ],
      ),
    );
  }
}

// ===== شريط التقدم =====
class _ProgressBar extends StatelessWidget {
  final double progress;
  final int current;
  final int total;
  const _ProgressBar({required this.progress, required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.cardColor,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('🗺️ رحلة الذكر',
                style: TextStyle(color: AppTheme.accentGold, fontSize: 12, fontWeight: FontWeight.bold)),
            Text('$current / $total',
                style: const TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: AppTheme.borderColor,
            valueColor: AlwaysStoppedAnimation(
              Color.lerp(AppTheme.accentGreen, AppTheme.accentGold, progress)!,
            ),
            minHeight: 10,
          ),
        ),
      ]),
    );
  }
}

// ===== مؤشرات الخطوات =====
class _Steps extends StatelessWidget {
  final int total;
  final int current;
  const _Steps({required this.total, required this.current});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: List.generate(total, (i) {
          final done = i < current;
          final active = i == current;
          return Flexible(
            child: Row(children: [
              Container(
                width: active ? 30 : 22,
                height: active ? 30 : 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: done ? AppTheme.accentGreen : active ? AppTheme.accentGold : AppTheme.borderColor,
                  boxShadow: active
                      ? [BoxShadow(color: AppTheme.accentGold.withOpacity(0.5), blurRadius: 8, spreadRadius: 2)]
                      : null,
                ),
                child: Center(
                  child: done
                      ? const Icon(Icons.check, color: Colors.white, size: 13)
                      : Text('${i + 1}',
                          style: TextStyle(
                            color: active ? Colors.white : AppTheme.textSecondary,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          )),
                ),
              ),
              if (i < total - 1)
                Expanded(
                  child: Container(
                    height: 2,
                    color: i < current ? AppTheme.accentGreen : AppTheme.borderColor,
                  ),
                ),
            ]),
          );
        }),
      ),
    );
  }
}

// ===== عداد الذكر =====
class _Counter extends StatelessWidget {
  final DhikrItem dhikr;
  final int count;
  final int target;
  final Animation<double> pulseAnim;
  final VoidCallback onTap;
  final int index;
  final int total;
  const _Counter({
    required this.dhikr, required this.count, required this.target,
    required this.pulseAnim, required this.onTap,
    required this.index, required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        // ترقيم الذكر
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.accentGold.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.accentGold.withOpacity(0.4)),
          ),
          child: Text('الذكر ${index + 1} من $total',
              style: const TextStyle(color: AppTheme.accentGold, fontSize: 12)),
        ),
        const SizedBox(height: 12),

        // نص الذكر
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppTheme.cardColor,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppTheme.accentGreen.withOpacity(0.25)),
              ),
              child: Column(children: [
                Text(dhikr.arabic,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: AppTheme.textPrimary, fontSize: 19, height: 1.9)),
                if (dhikr.source != null) ...[
                  const SizedBox(height: 6),
                  Text('📖 ${dhikr.source}',
                      style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
                ],
                if (dhikr.virtue != null) ...[
                  const SizedBox(height: 6),
                  Text('✨ ${dhikr.virtue}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppTheme.accentGold, fontSize: 11)),
                ],
              ]),
            ),
          ),
        ),
        const SizedBox(height: 14),

        // شريط تقدم الذكر الحالي
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: count / target,
            backgroundColor: AppTheme.borderColor,
            color: AppTheme.accentGreen,
            minHeight: 6,
          ),
        ),
        const SizedBox(height: 14),

        // زر العد
        GestureDetector(
          onTap: onTap,
          child: ScaleTransition(
            scale: pulseAnim,
            child: Container(
              width: 155,
              height: 155,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [AppTheme.accentGreen, AppTheme.accentGreen.withOpacity(0.75)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.accentGreen.withOpacity(0.4),
                    blurRadius: 24, spreadRadius: 4,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('$count',
                      style: const TextStyle(
                          color: Colors.white, fontSize: 52, fontWeight: FontWeight.bold)),
                  Text('من $target',
                      style: const TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Text('اضغط للتسبيح',
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
        const SizedBox(height: 8),
      ]),
    );
  }
}

// ===== بطاقة إتمام الذكر =====
class _MiniCompletion extends StatelessWidget {
  final DhikrItem dhikr;
  final int points;
  final Animation<double> celebrateAnim;
  final bool isLast;
  final VoidCallback onNext;
  const _MiniCompletion({
    required this.dhikr, required this.points, required this.celebrateAnim,
    required this.isLast, required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: celebrateAnim,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1E2E1A), Color(0xFF2A3E24)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppTheme.accentGreen.withOpacity(0.6), width: 2),
            boxShadow: [
              BoxShadow(
                  color: AppTheme.accentGreen.withOpacity(0.2), blurRadius: 20, spreadRadius: 4),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('✅', style: TextStyle(fontSize: 56)),
              const SizedBox(height: 12),
              Text(dhikr.meaning,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: AppTheme.accentGreen, fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text('أتممت $points مرة',
                  style: const TextStyle(color: AppTheme.textPrimary, fontSize: 15)),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                decoration: BoxDecoration(
                  color: AppTheme.accentGold.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.accentGold.withOpacity(0.4)),
                ),
                child: Text('⭐ +$points نقطة',
                    style: const TextStyle(color: AppTheme.accentGold, fontWeight: FontWeight.bold)),
              ),
              if (dhikr.virtue != null) ...[
                const SizedBox(height: 10),
                Text('✨ ${dhikr.virtue}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppTheme.accentGold, fontSize: 11)),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: isLast ? AppTheme.accentGold : AppTheme.accentGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: onNext,
                  child: Text(
                    isLast ? '🏆 إنهاء الرحلة' : 'الذكر التالي ←',
                    style: const TextStyle(
                        fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===== شاشة إتمام الرحلة =====
class _JourneyComplete extends StatelessWidget {
  final String categoryName;
  final String categoryIcon;
  final int totalPoints;
  final int totalDhikr;
  final VoidCallback onRestart;

  const _JourneyComplete({
    required this.categoryName, required this.categoryIcon,
    required this.totalPoints, required this.totalDhikr, required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(categoryIcon, style: const TextStyle(fontSize: 64)),
                const Text('🏆🎉🏆', style: TextStyle(fontSize: 32)),
                const SizedBox(height: 20),
                const Text('ما شاء الله!',
                    style: TextStyle(
                        color: AppTheme.accentGold, fontSize: 14, fontWeight: FontWeight.w500)),
                Text('أكملت رحلة $categoryName',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: AppTheme.accentGreen, fontSize: 26, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.cardColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.accentGold.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _Stat('📿', '$totalDhikr', 'أذكار مكتملة'),
                      Container(width: 1, height: 50, color: AppTheme.borderColor),
                      _Stat('⭐', '$totalPoints', 'نقطة مكتسبة'),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
                    child: const Text('العودة للرئيسية', style: TextStyle(fontSize: 17)),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: onRestart,
                  child: const Text('إعادة الرحلة 🔄',
                      style: TextStyle(color: AppTheme.textSecondary)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String emoji;
  final String value;
  final String label;
  const _Stat(this.emoji, this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(emoji, style: const TextStyle(fontSize: 26)),
      const SizedBox(height: 4),
      Text(value,
          style: const TextStyle(
              color: AppTheme.accentGold, fontSize: 22, fontWeight: FontWeight.bold)),
      Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 10)),
    ]);
  }
}
