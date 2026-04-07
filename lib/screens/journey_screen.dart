import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
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
  int _currentDhikrIndex = 0;
  int _count = 0;
  int _customTarget = 0;
  bool _showingCompletion = false;
  bool _journeyComplete = false;
  int _totalPoints = 0;

  late AnimationController _pulseCtrl;
  late AnimationController _slideCtrl;
  late AnimationController _celebrateCtrl;
  late Animation<double> _pulseAnim;
  late Animation<Offset> _slideAnim;
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

    _slideCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _slideAnim = Tween<Offset>(begin: Offset.zero, end: const Offset(-1.5, 0))
        .animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeInOut));

    _celebrateCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _celebrateAnim = CurvedAnimation(parent: _celebrateCtrl, curve: Curves.elasticOut);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _slideCtrl.dispose();
    _celebrateCtrl.dispose();
    super.dispose();
  }

  DhikrItem get _currentDhikr => widget.category.adhkar[_currentDhikrIndex];
  int get _totalDhikr => widget.category.adhkar.length;
  double get _journeyProgress => (_currentDhikrIndex + (_count / _customTarget).clamp(0, 1)) / _totalDhikr;

  Future<void> _onTap() async {
    HapticFeedback.lightImpact();
    _pulseCtrl.forward().then((_) => _pulseCtrl.reverse());

    final newCount = _count + 1;

    await StorageService.incrementTodayCount();
    await StorageService.incrementTotalCount();

    if (newCount >= _customTarget) {
      // اكتمل الذكر الحالي
      _celebrateCtrl.forward(from: 0);
      _totalPoints += _customTarget;
      setState(() {
        _count = _customTarget;
        _showingCompletion = true;
      });
    } else {
      setState(() => _count = newCount);
    }
  }

  Future<void> _nextDhikr() async {
    if (_currentDhikrIndex >= _totalDhikr - 1) {
      // انتهت الرحلة كلها
      await StorageService.updateStreak();
      setState(() {
        _journeyComplete = true;
        _showingCompletion = false;
      });
    } else {
      // انتقل للذكر التالي
      await _slideCtrl.forward();
      setState(() {
        _currentDhikrIndex++;
        _count = 0;
        _customTarget = widget.category.adhkar[_currentDhikrIndex].count;
        _showingCompletion = false;
      });
      _slideCtrl.reset();
    }
  }

  void _showCustomCountDialog() {
    final ctrl = TextEditingController(text: '$_customTarget');
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        title: const Text('تحديد العداد', style: TextStyle(color: AppTheme.textPrimary)),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppTheme.textPrimary, fontSize: 24),
          decoration: const InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppTheme.accentGreen),
            ),
          ),
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
                  _showingCompletion = false;
                });
              }
              Navigator.pop(context);
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_journeyComplete) return _JourneyCompleteScreen(
      categoryName: widget.category.name,
      totalPoints: _totalPoints,
      totalDhikr: _totalDhikr,
      onRestart: () => setState(() {
        _currentDhikrIndex = 0;
        _count = 0;
        _customTarget = widget.category.adhkar[0].count;
        _journeyComplete = false;
        _totalPoints = 0;
      }),
    );

    return Scaffold(
      backgroundColor: AppTheme.bgColor,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.category.icon, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Text(widget.category.name),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune, color: AppTheme.accentGold),
            onPressed: _showCustomCountDialog,
            tooltip: 'تحديد العداد',
          ),
        ],
      ),
      body: Column(
        children: [
          // شريط تقدم الرحلة الكاملة
          _JourneyProgressBar(
            progress: _journeyProgress,
            current: _currentDhikrIndex + 1,
            total: _totalDhikr,
          ),

          // مؤشرات الخطوات
          _StepsIndicator(
            total: _totalDhikr,
            current: _currentDhikrIndex,
            completed: List.generate(_currentDhikrIndex, (i) => i),
          ),

          Expanded(
            child: _showingCompletion
                ? _DhikrCompletionCard(
                    dhikr: _currentDhikr,
                    points: _customTarget,
                    celebrateAnim: _celebrateAnim,
                    isLast: _currentDhikrIndex >= _totalDhikr - 1,
                    onNext: _nextDhikr,
                  )
                : SlideTransition(
                    position: _slideAnim,
                    child: _DhikrCounterCard(
                      dhikr: _currentDhikr,
                      count: _count,
                      target: _customTarget,
                      pulseAnim: _pulseAnim,
                      onTap: _onTap,
                      dhikrIndex: _currentDhikrIndex,
                      totalDhikr: _totalDhikr,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// ===== شريط تقدم الرحلة =====
class _JourneyProgressBar extends StatelessWidget {
  final double progress;
  final int current;
  final int total;
  const _JourneyProgressBar({required this.progress, required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.cardColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('🗺️ رحلة الذكر', style: const TextStyle(color: AppTheme.accentGold, fontSize: 12, fontWeight: FontWeight.bold)),
              Text('$current / $total', style: const TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppTheme.borderColor,
              valueColor: AlwaysStoppedAnimation<Color>(
                Color.lerp(AppTheme.accentGreen, AppTheme.accentGold, progress)!,
              ),
              minHeight: 10,
            ),
          ),
        ],
      ),
    );
  }
}

// ===== مؤشرات الخطوات =====
class _StepsIndicator extends StatelessWidget {
  final int total;
  final int current;
  final List<int> completed;
  const _StepsIndicator({required this.total, required this.current, required this.completed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(total, (i) {
          final isCompleted = i < current;
          final isCurrent = i == current;
          return Flexible(
            child: Row(
              children: [
                Container(
                  width: isCurrent ? 32 : 24,
                  height: isCurrent ? 32 : 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted
                        ? AppTheme.accentGreen
                        : isCurrent
                            ? AppTheme.accentGold
                            : AppTheme.borderColor,
                    boxShadow: isCurrent
                        ? [BoxShadow(color: AppTheme.accentGold.withOpacity(0.5), blurRadius: 8, spreadRadius: 2)]
                        : null,
                  ),
                  child: Center(
                    child: isCompleted
                        ? const Icon(Icons.check, color: Colors.white, size: 14)
                        : Text('${i + 1}',
                            style: TextStyle(
                              color: isCurrent ? Colors.white : AppTheme.textSecondary,
                              fontSize: 11,
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
              ],
            ),
          );
        }),
      ),
    );
  }
}

// ===== بطاقة عداد الذكر =====
class _DhikrCounterCard extends StatelessWidget {
  final DhikrItem dhikr;
  final int count;
  final int target;
  final Animation<double> pulseAnim;
  final VoidCallback onTap;
  final int dhikrIndex;
  final int totalDhikr;

  const _DhikrCounterCard({
    required this.dhikr, required this.count, required this.target,
    required this.pulseAnim, required this.onTap,
    required this.dhikrIndex, required this.totalDhikr,
  });

  @override
  Widget build(BuildContext context) {
    final progress = count / target;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // رقم الذكر
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.accentGold.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.accentGold.withOpacity(0.4)),
            ),
            child: Text(
              'الذكر ${dhikrIndex + 1} من $totalDhikr',
              style: const TextStyle(color: AppTheme.accentGold, fontSize: 12),
            ),
          ),
          const SizedBox(height: 16),

          // نص الذكر
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppTheme.cardColor, AppTheme.card2Color],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.accentGreen.withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        Text(
                          dhikr.arabic,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppTheme.textPrimary, fontSize: 20, height: 2.0,
                          ),
                        ),
                        if (dhikr.source != null) ...[
                          const SizedBox(height: 8),
                          Text('📖 ${dhikr.source}',
                              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                        ],
                        if (dhikr.virtue != null) ...[
                          const SizedBox(height: 8),
                          Text('✨ ${dhikr.virtue}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: AppTheme.accentGold, fontSize: 12)),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // شريط تقدم الذكر الحالي
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppTheme.borderColor,
              color: AppTheme.accentGreen,
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 16),

          // زر العد
          GestureDetector(
            onTap: onTap,
            child: ScaleTransition(
              scale: pulseAnim,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [AppTheme.accentGreen, AppTheme.accentGreen.withOpacity(0.7)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.accentGreen.withOpacity(0.4),
                      blurRadius: 25, spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('$count',
                        style: const TextStyle(color: Colors.white, fontSize: 52, fontWeight: FontWeight.bold)),
                    Text('من $target',
                        style: const TextStyle(color: Colors.white70, fontSize: 13)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text('اضغط للتسبيح',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

// ===== بطاقة إتمام الذكر =====
class _DhikrCompletionCard extends StatelessWidget {
  final DhikrItem dhikr;
  final int points;
  final Animation<double> celebrateAnim;
  final bool isLast;
  final VoidCallback onNext;

  const _DhikrCompletionCard({
    required this.dhikr, required this.points, required this.celebrateAnim,
    required this.isLast, required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: celebrateAnim,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1E2E1A), Color(0xFF2A3E24)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppTheme.accentGreen.withOpacity(0.5), width: 2),
            boxShadow: [
              BoxShadow(
                color: AppTheme.accentGreen.withOpacity(0.2),
                blurRadius: 20, spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('✅', style: TextStyle(fontSize: 60)),
              const SizedBox(height: 16),
              Text(
                dhikr.meaning,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppTheme.accentGreen, fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'أتممت ${dhikr.count} مرة',
                style: const TextStyle(color: AppTheme.textPrimary, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.accentGold.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.accentGold.withOpacity(0.4)),
                ),
                child: Text(
                  '⭐ +$points نقطة',
                  style: const TextStyle(color: AppTheme.accentGold, fontWeight: FontWeight.bold),
                ),
              ),
              if (dhikr.virtue != null) ...[
                const SizedBox(height: 12),
                Text(
                  '✨ ${dhikr.virtue}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppTheme.accentGold, fontSize: 12),
                ),
              ],
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    backgroundColor: isLast ? AppTheme.accentGold : AppTheme.accentGreen,
                  ),
                  onPressed: onNext,
                  child: Text(
                    isLast ? '🏆 إنهاء الرحلة' : 'التالي ←',
                    style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
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

// ===== شاشة إتمام الرحلة كاملة =====
class _JourneyCompleteScreen extends StatelessWidget {
  final String categoryName;
  final int totalPoints;
  final int totalDhikr;
  final VoidCallback onRestart;

  const _JourneyCompleteScreen({
    required this.categoryName, required this.totalPoints,
    required this.totalDhikr, required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // احتفال
                const Text('🏆', style: TextStyle(fontSize: 80)),
                const SizedBox(height: 8),
                const Text('🎉🎉🎉', style: TextStyle(fontSize: 32)),
                const SizedBox(height: 24),
                Text(
                  'أحسنت! أكملت رحلة',
                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 16),
                ),
                Text(
                  categoryName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppTheme.accentGreen, fontSize: 28, fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

                // إحصائيات
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
                      _StatItem(emoji: '📿', value: '$totalDhikr', label: 'أذكار مكتملة'),
                      Container(width: 1, height: 50, color: AppTheme.borderColor),
                      _StatItem(emoji: '⭐', value: '$totalPoints', label: 'نقطة مكتسبة'),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
                    child: const Text('العودة للرئيسية', style: TextStyle(fontSize: 18)),
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

class _StatItem extends StatelessWidget {
  final String emoji;
  final String value;
  final String label;
  const _StatItem({required this.emoji, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 28)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(
          color: AppTheme.accentGold, fontSize: 24, fontWeight: FontWeight.bold,
        )),
        Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
      ],
    );
  }
}
