// dhikr_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../models/types.dart';
import '../services/storage_service.dart';
import 'tasbeeh_counter_screen.dart';

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
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
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
                  if (isCompleted)
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text('✅ مكتمل اليوم',
                          style: TextStyle(color: AppTheme.successColor, fontSize: 11)),
                    ),
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
                            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12))
                      else
                        const SizedBox(),
                      Row(
                        children: [
                          // نسخ
                          IconButton(
                            icon: const Icon(Icons.copy_outlined, color: AppTheme.textSecondary, size: 18),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: d.arabic));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('تم النسخ ✅'), duration: Duration(seconds: 1)),
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
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.accentGreen.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppTheme.accentGreen),
                            ),
                            child: Text('${d.count}×',
                                style: const TextStyle(
                                  color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 13,
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
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => TasbeehCounterScreen(dhikr: d)))
                        .then((_) => _loadData()),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
