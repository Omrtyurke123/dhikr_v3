import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../data/adhkar_data.dart';
import '../models/types.dart';
import '../services/storage_service.dart';

class AyahScreen extends StatefulWidget {
  const AyahScreen({super.key});

  @override
  State<AyahScreen> createState() => _AyahScreenState();
}

class _AyahScreenState extends State<AyahScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    StorageService.getAyahIndex().then((idx) {
      setState(() => _currentIndex = idx % AdhkarData.dailyAyahs.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ayahs = AdhkarData.dailyAyahs;
    final ayah = ayahs[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('آيات قرآنية'),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy_outlined),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: ayah.arabic));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم نسخ الآية ✅')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // مؤشر التقدم
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${_currentIndex + 1} / ${ayahs.length}',
                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                Text('سورة ${ayah.surahName}',
                    style: const TextStyle(color: AppTheme.accentGold, fontSize: 12)),
              ],
            ),
          ),

          // الآية الرئيسية
          Expanded(
            child: PageView.builder(
              itemCount: ayahs.length,
              onPageChanged: (i) => setState(() => _currentIndex = i),
              controller: PageController(initialPage: _currentIndex),
              itemBuilder: (_, i) => _AyahCard(ayah: ayahs[i]),
            ),
          ),

          // أزرار التنقل
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.cardColor),
                  icon: const Icon(Icons.arrow_forward, color: AppTheme.accentGreen),
                  label: const Text('السابقة', style: TextStyle(color: AppTheme.textPrimary)),
                  onPressed: _currentIndex > 0
                      ? () => setState(() => _currentIndex--)
                      : null,
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.cardColor),
                  icon: const Icon(Icons.arrow_back, color: AppTheme.accentGreen),
                  label: const Text('التالية', style: TextStyle(color: AppTheme.textPrimary)),
                  onPressed: _currentIndex < ayahs.length - 1
                      ? () => setState(() => _currentIndex++)
                      : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AyahCard extends StatelessWidget {
  final QuranAyah ayah;
  const _AyahCard({required this.ayah});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1E2E1A), Color(0xFF2A3E24)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.accentGreen.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.accentGold.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.accentGold.withOpacity(0.5)),
              ),
              child: Text(
                'سورة ${ayah.surahName} • آية ${ayah.ayahNumber}',
                style: const TextStyle(color: AppTheme.accentGold, fontSize: 12),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              ayah.arabic,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 22,
                height: 2.0,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: 60,
              height: 1,
              color: AppTheme.accentGreen.withOpacity(0.4),
            ),
            const SizedBox(height: 16),
            Text(
              ayah.meaning,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
