import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/types.dart';
import '../theme/app_theme.dart';
import '../services/storage_service.dart';

class ChallengeCounterScreen extends StatefulWidget {
  final DailyChallenge challenge;
  const ChallengeCounterScreen({super.key, required this.challenge});

  @override
  State<ChallengeCounterScreen> createState() => _ChallengeCounterScreenState();
}

class _ChallengeCounterScreenState extends State<ChallengeCounterScreen>
    with SingleTickerProviderStateMixin {
  late int _count;
  late AnimationController _animCtrl;
  late Animation<double> _scaleAnim;
  bool _hapticEnabled = true;

  @override
  void initState() {
    super.initState();
    _count = widget.challenge.currentCount;
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.91)
        .animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeInOut));
    StorageService.getHapticEnabled().then((v) => setState(() => _hapticEnabled = v));
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  Future<void> _increment() async {
    if (_count >= widget.challenge.targetCount) return;
    if (_hapticEnabled) HapticFeedback.lightImpact();
    _animCtrl.forward().then((_) => _animCtrl.reverse());

    final newCount = _count + 1;
    setState(() => _count = newCount);

    // تحديث التحدي
    final updated = DailyChallenge(
      id: widget.challenge.id,
      name: widget.challenge.name,
      dhikrId: widget.challenge.dhikrId,
      dhikrText: widget.challenge.dhikrText,
      targetCount: widget.challenge.targetCount,
      currentCount: newCount,
      createdAt: widget.challenge.createdAt,
      isCompleted: newCount >= widget.challenge.targetCount,
    );
    await StorageService.updateChallenge(updated);
    await StorageService.incrementTodayCount();
    await StorageService.incrementTotalCount();

    if (newCount >= widget.challenge.targetCount) {
      // اكتمل التحدي
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) _showCompletionDialog();
      });
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        title: const Text('🎉 تهانينا!',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppTheme.accentGold, fontSize: 24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'أكملت تحدي "${widget.challenge.name}"',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              '${widget.challenge.targetCount} مرة ✅',
              style: const TextStyle(
                color: AppTheme.accentGreen, fontSize: 22, fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 44)),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('العودة للتحديات'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_count / widget.challenge.targetCount).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.challenge.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              setState(() => _count = 0);
              final updated = DailyChallenge(
                id: widget.challenge.id,
                name: widget.challenge.name,
                dhikrId: widget.challenge.dhikrId,
                dhikrText: widget.challenge.dhikrText,
                targetCount: widget.challenge.targetCount,
                currentCount: 0,
                createdAt: widget.challenge.createdAt,
                isCompleted: false,
              );
              await StorageService.updateChallenge(updated);
            },
          ),
        ],
      ),
      body: Column(
        children: [
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
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppTheme.cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.borderColor),
                      ),
                      child: Text(
                        widget.challenge.dhikrText,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppTheme.textPrimary, fontSize: 18, height: 1.8,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // هدف التحدي
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.accentGold.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.accentGold.withOpacity(0.4)),
                    ),
                    child: Text(
                      '🎯 هدف التحدي: ${widget.challenge.targetCount} مرة',
                      style: const TextStyle(color: AppTheme.accentGold, fontSize: 13),
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
                            colors: [AppTheme.accentGreen, AppTheme.accentGreen.withOpacity(0.7)],
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
                            Text('من ${widget.challenge.targetCount}',
                                style: const TextStyle(color: Colors.white70, fontSize: 14)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('اضغط للعد',
                      style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
