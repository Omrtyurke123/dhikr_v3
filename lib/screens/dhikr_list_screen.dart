import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../models/types.dart';
import '../services/storage_service.dart';
import 'tasbeeh_counter_screen.dart';
import 'journey_screen.dart';

class DhikrDetailScreen extends StatefulWidget {
  final DhikrCategory category;
  const DhikrDetailScreen({super.key, required this.category});

  @override
  State<DhikrDetailScreen> createState() => _DhikrDetailScreenState();
}

class _DhikrDetailScreenState extends State<DhikrDetailScreen> {
  List<String> _favorites = [];
  List<String> _completedToday = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final favs = await StorageService.getFavorites();
    final completed = await StorageService.getCompletedToday();
    setState(() {
      _favorites = favs;
      _completedToday = completed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.category.name)),
      body: Column(
        children: [
          // ===== زر الرحلة في الأعلى =====
          Padding(
            padding: const EdgeInsets.all(12),
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => JourneyScreen(category: widget.category),
                ),
              ).then((_) => _loadData()),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2A3E1A), Color(0xFF1E4A2A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.accentGold.withOpacity(0.5)),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.accentGreen.withOpacity(0.2),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Text('🗺️', style: TextStyle(fontSize: 32)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'ابدأ رحلة الذكر 🎮',
                            style: TextStyle(
                              color: AppTheme.accentGold,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'رحلة متكاملة من أول ذكر لآخره مع نقاط ومكافآت',
                            style: TextStyle(
                              color: AppTheme.textSecondary.withOpacity(0.8),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_back_ios,
                        color: AppTheme.accentGold, size: 16),
                  ],
                ),
              ),
            ),
          ),

          // خط فاصل
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(child: Divider(color: AppTheme.borderColor)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text('أو اختر ذكراً',
                      style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                ),
                Expanded(child: Divider(color: AppTheme.borderColor)),
              ],
            ),
          ),

          // ===== قائمة الأذكار العادية =====
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              itemCount: widget.category.adhkar.length,
              itemBuilder: (_, i) {
                final d = widget.category.adhkar[i];
                final isFav = _favorites.contains(d.id);
                final isCompleted = _completedToday.contains(d.id);
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // رقم الذكر + مكتمل
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.borderColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text('${i + 1}',
                                  style: const TextStyle(
                                    color: AppTheme.textSecondary, fontSize: 11,
                                  )),
                            ),
                            if (isCompleted)
                              const Text('✅ مكتمل اليوم',
                                  style: TextStyle(color: AppTheme.successColor, fontSize: 11)),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // نص الذكر
                        Text(d.arabic,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppTheme.textPrimary, fontSize: 20, height: 1.8,
                            )),

                        if (d.virtue != null) ...[
                          const SizedBox(height: 8),
                          Text('✨ ${d.virtue}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: AppTheme.accentGold, fontSize: 12)),
                        ],

                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (d.source != null)
                              Text('📖 ${d.source}',
                                  style: const TextStyle(
                                    color: AppTheme.textSecondary, fontSize: 12,
                                  ))
                            else
                              const SizedBox(),
                            Row(
                              children: [
                                // نسخ
                                IconButton(
                                  icon: const Icon(Icons.copy_outlined,
                                      color: AppTheme.textSecondary, size: 18),
                                  onPressed: () {
                                    Clipboard.setData(ClipboardData(text: d.arabic));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('تم النسخ ✅'),
                                        duration: Duration(seconds: 1),
                                      ),
                                    );
                                  },
                                ),
                                // مفضلة
                                IconButton(
                                  icon: Icon(
                                    isFav ? Icons.favorite : Icons.favorite_outline,
                                    color: isFav ? AppTheme.dangerColor : AppTheme.textSecondary,
                                    size: 18,
                                  ),
                                  onPressed: () async {
                                    await StorageService.toggleFavorite(d.id);
                                    await _loadData();
                                  },
                                ),
                                // عدد المرات
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppTheme.accentGreen.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: AppTheme.accentGreen),
                                  ),
                                  child: Text('${d.count}×',
                                      style: const TextStyle(
                                        color: AppTheme.accentGreen,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      )),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.touch_app, size: 16),
                          label: const Text('ابدأ التسبيح'),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TasbeehCounterScreen(dhikr: d),
                            ),
                          ).then((_) => _loadData()),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
