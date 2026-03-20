import 'package:flutter/material.dart';
import '../models/types.dart';
import '../theme/app_theme.dart';

class CompletionScreen extends StatelessWidget {
  final DhikrItem dhikr;
  const CompletionScreen({super.key, required this.dhikr});

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
                const Text('🎉', style: TextStyle(fontSize: 80)),
                const SizedBox(height: 24),
                const Text('أحسنت!',
                    style: TextStyle(
                      color: AppTheme.accentGreen, fontSize: 38, fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 12),
                Text('أتممت ${dhikr.count} مرة',
                    style: const TextStyle(color: AppTheme.textPrimary, fontSize: 22)),
                const SizedBox(height: 8),
                Text(dhikr.meaning,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 16)),
                if (dhikr.virtue != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.accentGold.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.accentGold.withOpacity(0.3)),
                    ),
                    child: Text('✨ ${dhikr.virtue}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppTheme.accentGold, fontSize: 13)),
                  ),
                ],
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
                    child: const Text('العودة للرئيسية', style: TextStyle(fontSize: 18)),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('تكرار الذكر',
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
