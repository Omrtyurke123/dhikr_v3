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
  bool _hapticEnabled = true;
  late AnimationController _animCtrl;
  late Animation<double> _scaleAnim;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.91).animate(
      CurvedAnimation(parent: _animCtrl, curve: Curves.easeInOut),
    );
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

    // تحقق من إكمال الهدف
    final total = await StorageService.getTodayCount();
    final goal = await StorageService.getDailyGoal();
    if (total >= goal) await StorageService.updateStreak();

    if (_count >= widget.dhikr.count) {
      await StorageService.markDhikrCompleted(widget.dhikr.id);
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (_) => CompletionScreen(dhikr: widget.dhikr),
          ));
        }
      });
    }
  }

  Future<void> _toggleFavorite() async {
    await StorageService.toggleFavorite(widget.dhikr.id);
    final favs = await StorageService.getFavorites();
    setState(() => _isFavorite = favs.contains(widget.dhikr.id));
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_count / widget.dhikr.count).clamp(0.0, 1.0);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.dhikr.meaning),
        actions: [
          IconButton(
            icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_outline,
                color: _isFavorite ? AppTheme.dangerColor : AppTheme.textSecondary),
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
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // نص الذكر
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      widget.dhikr.arabic,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppTheme.textPrimary, fontSize: 22, height: 1.8,
                      ),
                    ),
                  ),
                  if (widget.dhikr.virtue != null) ...[
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        '✨ ${widget.dhikr.virtue}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppTheme.accentGold, fontSize: 12),
                      ),
                    ),
                  ],
                  const SizedBox(height: 40),
                  // زر العد
                  GestureDetector(
                    onTap: _increment,
                    child: ScaleTransition(
                      scale: _scaleAnim,
                      child: Container(
                        width: 190,
                        height: 190,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              AppTheme.accentGreen,
                              AppTheme.accentGreen.withOpacity(0.75),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.accentGreen.withOpacity(0.35),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '$_count',
                              style: const TextStyle(
                                color: Colors.white, fontSize: 64, fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'من ${widget.dhikr.count}',
                              style: const TextStyle(color: Colors.white70, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('اضغط للتسبيح',
                      style: TextStyle(color: AppTheme.textSecondary.withOpacity(0.7), fontSize: 13)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
