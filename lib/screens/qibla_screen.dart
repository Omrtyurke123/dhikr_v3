import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/app_theme.dart';

class QiblaScreen extends StatelessWidget {
  const QiblaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('اتجاه القبلة')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.cardColor,
                border: Border.all(color: AppTheme.accentGreen, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.accentGreen.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // خطوط الاتجاهات
                  ...List.generate(12, (i) {
                    final angle = i * 30.0 * math.pi / 180;
                    return Transform.rotate(
                      angle: angle,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          width: i % 3 == 0 ? 2 : 1,
                          height: i % 3 == 0 ? 16 : 10,
                          color: i % 3 == 0
                              ? AppTheme.textSecondary
                              : AppTheme.borderColor,
                        ),
                      ),
                    );
                  }),
                  // رمز الكعبة
                  const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('🕋', style: TextStyle(fontSize: 40)),
                      SizedBox(height: 4),
                      Text('مكة المكرمة',
                          style: TextStyle(color: AppTheme.accentGold, fontSize: 12)),
                    ],
                  ),
                  // سهم الشمال
                  Positioned(
                    top: 16,
                    child: Column(
                      children: [
                        const Text('N', style: TextStyle(color: AppTheme.accentGreen, fontSize: 12, fontWeight: FontWeight.bold)),
                        Container(width: 2, height: 20, color: AppTheme.accentGreen),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.borderColor),
              ),
              child: const Column(
                children: [
                  Icon(Icons.info_outline, color: AppTheme.accentGold),
                  SizedBox(height: 8),
                  Text(
                    'لتفعيل اتجاه القبلة الدقيق، يحتاج التطبيق إذن الموقع الجغرافي',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'اتجاه القبلة من مصر: شمال شرق (حوالي 50°)',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppTheme.textPrimary, fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
