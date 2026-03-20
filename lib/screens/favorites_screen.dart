import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/storage_service.dart';
import '../data/adhkar_data.dart';
import '../models/types.dart';
import 'tasbeeh_counter_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<DhikrItem> _favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final ids = await StorageService.getFavorites();
    final allDhikr = AdhkarData.categories.expand((c) => c.adhkar).toList();
    setState(() {
      _favorites = allDhikr.where((d) => ids.contains(d.id)).toList();
    });
  }

  Future<void> _removeFavorite(String id) async {
    await StorageService.toggleFavorite(id);
    await _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('المفضلة ❤️')),
      body: _favorites.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('❤️', style: TextStyle(fontSize: 60)),
                  SizedBox(height: 16),
                  Text('لا يوجد مفضلة بعد',
                      style: TextStyle(color: AppTheme.textPrimary, fontSize: 18)),
                  SizedBox(height: 8),
                  Text('اضغط على ❤️ في أي ذكر لإضافته',
                      style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _favorites.length,
              itemBuilder: (_, i) {
                final d = _favorites[i];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(d.arabic,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppTheme.textPrimary, fontSize: 18, height: 1.8,
                            )),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (d.source != null)
                              Text('📖 ${d.source}',
                                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                            Row(
                              children: [
                                TextButton(
                                  onPressed: () => Navigator.push(context,
                                    MaterialPageRoute(builder: (_) => TasbeehCounterScreen(dhikr: d))),
                                  child: const Text('▶ تسبيح',
                                      style: TextStyle(color: AppTheme.accentGreen)),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.favorite, color: AppTheme.dangerColor, size: 20),
                                  onPressed: () => _removeFavorite(d.id),
                                ),
                              ],
                            ),
                          ],
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
