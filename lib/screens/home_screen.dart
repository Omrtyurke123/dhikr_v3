import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/storage_service.dart';
import '../models/types.dart';
import '../data/adhkar_data.dart';
import 'dhikr_list_screen.dart';
import 'tasbeeh_screen.dart';
import 'challenges_screen.dart';
import 'qibla_screen.dart';
import 'settings_screen.dart';
import 'favorites_screen.dart';
import 'ayah_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _todayCount = 0;
  int _dailyGoal = 1000;
  int _streak = 0;
  int _longestStreak = 0;
  int _totalCount = 0;
  QuranAyah? _todayAyah;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    final count = await StorageService.getTodayCount();
    final goal = await StorageService.getDailyGoal();
    final streak = await StorageService.checkStreakValidity();
    final total = await StorageService.getTotalCount();
    final ayahIdx = await StorageService.getAyahIndex();

    if (mounted) {
      setState(() {
        _todayCount = count;
        _dailyGoal = goal;
        _streak = streak.currentStreak;
        _longestStreak = streak.longestStreak;
        _totalCount = total;
        _todayAyah = AdhkarData.dailyAyahs[ayahIdx % AdhkarData.dailyAyahs.length];
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تطبيق الذكر'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_outline),
            color: AppTheme.accentGold,
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const FavoritesScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const SettingsScreen())).then((_) => _loadData()),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'الرئيسية', icon: Icon(Icons.home_outlined, size: 18)),
            Tab(text: 'التسبيح', icon: Icon(Icons.repeat_outlined, size: 18)),
            Tab(text: 'التحديات', icon: Icon(Icons.emoji_events_outlined, size: 18)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _HomeTab(
            todayCount: _todayCount,
            dailyGoal: _dailyGoal,
            streak: _streak,
            longestStreak: _longestStreak,
            totalCount: _totalCount,
            todayAyah: _todayAyah,
            onRefresh: _loadData,
          ),
          const TasbeehScreen(),
          const ChallengesScreen(),
        ],
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  final int todayCount;
  final int dailyGoal;
  final int streak;
  final int longestStreak;
  final int totalCount;
  final QuranAyah? todayAyah;
  final VoidCallback onRefresh;

  const _HomeTab({
    required this.todayCount,
    required this.dailyGoal,
    required this.streak,
    required this.longestStreak,
    required this.totalCount,
    required this.todayAyah,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (todayCount / dailyGoal).clamp(0.0, 1.0);
    final categories = AdhkarData.categories;

    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      color: AppTheme.accentGreen,
      backgroundColor: AppTheme.cardColor,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 20),
        children: [
          // ===== آية اليوم =====
          if (todayAyah != null) _AyahCard(ayah: todayAyah!),

          // ===== إحصائيات =====
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                _StatCard(emoji: '🔥', value: '$streak', label: 'streak يومي'),
                const SizedBox(width: 8),
                _StatCard(emoji: '📿', value: '$todayCount', label: 'اليوم'),
                const SizedBox(width: 8),
                _StatCard(emoji: '🏆', value: '$longestStreak', label: 'أطول streak'),
              ],
            ),
          ),

          // ===== الهدف اليومي =====
          _DailyGoalCard(todayCount: todayCount, dailyGoal: dailyGoal, progress: progress),

          // ===== إجمالي الأذكار =====
          _TotalCountCard(totalCount: totalCount),

          // ===== أزرار سريعة =====
          _QuickActions(context: context),

          // ===== قائمة الفئات =====
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text('الأذكار', style: TextStyle(
              color: AppTheme.textPrimary, fontSize: 18, fontWeight: FontWeight.bold,
            )),
          ),
          ...categories.map((cat) => _CategoryCard(category: cat)),
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
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AyahScreen())),
      child: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1E2E1A), Color(0xFF2A3E24)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.accentGreen.withOpacity(0.4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Text('📖', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                Text('آية اليوم • سورة ${ayah.surahName}',
                    style: const TextStyle(color: AppTheme.accentGold, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              ayah.arabic,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 18,
                height: 1.8,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              ayah.meaning,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String emoji;
  final String value;
  final String label;
  const _StatCard({required this.emoji, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(
              color: AppTheme.accentGreen, fontSize: 20, fontWeight: FontWeight.bold,
            )),
            Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}

class _DailyGoalCard extends StatelessWidget {
  final int todayCount;
  final int dailyGoal;
  final double progress;
  const _DailyGoalCard({required this.todayCount, required this.dailyGoal, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('🎯 الهدف اليومي', style: TextStyle(
                color: AppTheme.textPrimary, fontWeight: FontWeight.bold,
              )),
              Text('$todayCount / $dailyGoal',
                  style: const TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppTheme.borderColor,
              color: progress >= 1.0 ? AppTheme.successColor : AppTheme.accentGreen,
              minHeight: 8,
            ),
          ),
          if (progress >= 1.0) ...[
            const SizedBox(height: 8),
            const Text('🎉 أحسنت! أكملت هدفك اليوم',
                style: TextStyle(color: AppTheme.successColor, fontSize: 12)),
          ],
        ],
      ),
    );
  }
}

class _TotalCountCard extends StatelessWidget {
  final int totalCount;
  const _TotalCountCard({required this.totalCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Text('📊', style: TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('إجمالي الأذكار', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
              Text(
                _formatNumber(totalCount),
                style: const TextStyle(color: AppTheme.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatNumber(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}م';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}ك';
    return '$n';
  }
}

class _QuickActions extends StatelessWidget {
  final BuildContext context;
  const _QuickActions({required this.context});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          _QuickBtn(emoji: '🧭', label: 'القبلة', onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const QiblaScreen()))),
          const SizedBox(width: 8),
          _QuickBtn(emoji: '📖', label: 'آية اليوم', onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const AyahScreen()))),
          const SizedBox(width: 8),
          _QuickBtn(emoji: '❤️', label: 'المفضلة', onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const FavoritesScreen()))),
        ],
      ),
    );
  }
}

class _QuickBtn extends StatelessWidget {
  final String emoji;
  final String label;
  final VoidCallback onTap;
  const _QuickBtn({required this.emoji, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.card2Color,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.borderColor),
          ),
          child: Column(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 22)),
              const SizedBox(height: 4),
              Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final DhikrCategory category;
  const _CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Text(category.icon, style: const TextStyle(fontSize: 28)),
        title: Text(category.name, style: const TextStyle(
          color: AppTheme.textPrimary, fontSize: 16, fontWeight: FontWeight.bold,
        )),
        subtitle: Text(
          category.description ?? '${category.adhkar.length} أذكار',
          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(Icons.arrow_back_ios, color: AppTheme.accentGreen, size: 14),
        onTap: () => Navigator.push(context, MaterialPageRoute(
          builder: (_) => DhikrDetailScreen(category: category),
        )),
      ),
    );
  }
}
