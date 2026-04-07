import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/types.dart';
import '../theme/app_theme.dart';
import '../services/storage_service.dart';
import 'completion_screen.dart';

class TasbeehCounterScreen extends StatefulWidget {
  final DhikrItem dhikr;
  const TasbeehCounterScreen({super.key, required this.dhikr});

  @override
  State<TasbeehCounterScreen> createState() => _TasbeehCounterScreenState();
}

class _TasbeehCounterScreenState extends State<TasbeehCounterScreen>
    with SingleTickerProviderStateMixin {
  int _count = 0;
  late int _customTarget;
  bool _hapticEnabled = true;
  bool _isFavorite = false;
  late AnimationController _animCtrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _customTarget = widget.dhikr.count;
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.91)
        .animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeInOut));
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final haptic = await StorageService.getHapticEnabled();
    final favs = await StorageService.getFavorites();
    setState(() {
      _hapticEnabled = haptic;
      _isFavorite = favs.contains(widget.dhikr.id);
    });
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  Future<void> _increment() async {
    if (_hapticEnabled) HapticFeedback.lightImpact();
    _animCtrl.forward().then((_) => _animCtrl.reverse());
    setState(() => _count++);

    await StorageService.incrementTodayCount();
    await StorageService.incrementTotalCount();

    final total = await StorageService.getTodayCount();
    final goal = await StorageService.getDailyGoal();
    if (total >= goal) await StorageService.updateStreak();

    if (_count >= _customTarget) {
      await StorageService.markDhikrCompleted(widget.dhikr.id);
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => CompletionScreen(dhikr: widget.dhikr)),
          );
        }
      });
    }
  }

  void _showCustomCountDialog() {
    final ctrl = TextEditingController(text: '$_customTarget');
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        title: const Text('تحديد العداد',
            style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('حدد عدد التسبيحات المطلوبة',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
            const SizedBox(height: 12),
            TextField(
              controller: ctrl,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppTheme.textPrimary, fontSize: 28, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.accentGreen, width: 2),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.accentGold, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // أزرار سريعة
            Wrap(
              spacing: 8,
              children: [33, 50, 100, 200, 500].map((n) =>
                GestureDetector(
                  onTap: () => ctrl.text = '$n',
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.accentGreen.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.accentGreen.withOpacity(0.4)),
                    ),
                    child: Text('$n', style: const TextStyle(color: AppTheme.accentGreen, fontSize: 12)),
                  ),
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

  Future<void> _toggleFavorite() async {
    await StorageService.toggleFavorite(widget.dhikr.id);
    final favs = await StorageService.getFavorites();
    setState(() => _isFavorite = favs.contains(widget.dhikr.id));
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_count / _customTarget).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.dhikr.meaning),
        actions: [
          // تحديد العداد
          IconButton(
            icon: const Icon(Icons.tune, color: AppTheme.accentGold),
            onPressed: _showCustomCountDialog,
            tooltip: 'تحديد العداد',
          ),
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_outline,
              color: _isFavorite ? AppTheme.dangerColor : AppTheme.textSecondary,
            ),
            onPressed: _toggleFavorite,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() => _count = 0),
          ),
        ],
      ),
      body: Column(
        children: [
          // شريط التقدم
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppTheme.borderColor,
            color: progress >= 1.0 ? AppTheme.successColor : AppTheme.accentGreen,
            minHeight: 6,
          ),

          // عرض العداد المحدد لو مختلف عن الأصلي
          if (_customTarget != widget.dhikr.count)
            Container(
              color: AppTheme.accentGold.withOpacity(0.1),
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Center(
                child: Text(
                  '⚙️ عداد مخصص: $_customTarget مرة',
                  style: const TextStyle(color: AppTheme.accentGold, fontSize: 12),
                ),
              ),
            ),

          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // نص الذكر
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppTheme.cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.borderColor),
                      ),
                      child: Column(
                        children: [
                          Text(
                            widget.dhikr.arabic,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppTheme.textPrimary, fontSize: 20, height: 1.8,
                            ),
                          ),
                          if (widget.dhikr.virtue != null) ...[
                            const SizedBox(height: 8),
                            Text('✨ ${widget.dhikr.virtue}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: AppTheme.accentGold, fontSize: 12)),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // زر العد
                  GestureDetector(
                    onTap: _increment,
                    child: ScaleTransition(
                      scale: _scaleAnim,
                      child: Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              AppTheme.accentGreen,
                              AppTheme.accentGreen.withOpacity(0.7),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.accentGreen.withOpacity(0.4),
                              blurRadius: 28, spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('$_count',
                                style: const TextStyle(
                                  color: Colors.white, fontSize: 60, fontWeight: FontWeight.bold,
                                )),
                            Text('من $_customTarget',
                                style: const TextStyle(color: Colors.white70, fontSize: 14)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: _showCustomCountDialog,
                    child: const Text('اضغط للتسبيح • اضغط ⚙️ لتغيير العداد',
                        style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
