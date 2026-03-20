import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/types.dart';

class StorageService {
  // ===== Challenges =====
  static Future<List<DailyChallenge>> getChallenges() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString('challenges');
    if (json == null) return [];
    final list = jsonDecode(json) as List;
    return list.map((e) => DailyChallenge.fromJson(e)).toList();
  }

  static Future<void> saveChallenges(List<DailyChallenge> challenges) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('challenges', jsonEncode(challenges.map((c) => c.toJson()).toList()));
  }

  static Future<void> addChallenge(DailyChallenge c) async {
    final list = await getChallenges();
    list.add(c);
    await saveChallenges(list);
  }

  static Future<void> updateChallenge(DailyChallenge updated) async {
    final list = await getChallenges();
    final idx = list.indexWhere((c) => c.id == updated.id);
    if (idx != -1) { list[idx] = updated; await saveChallenges(list); }
  }

  static Future<void> deleteChallenge(String id) async {
    final list = await getChallenges();
    list.removeWhere((c) => c.id == id);
    await saveChallenges(list);
  }

  // ===== Daily Stats =====
  static Future<int> getTodayCount() async {
    final prefs = await SharedPreferences.getInstance();
    final savedDate = prefs.getString('today_date');
    final today = DateTime.now().toIso8601String().substring(0, 10);
    if (savedDate != today) {
      await prefs.setString('today_date', today);
      await prefs.setInt('today_count', 0);
      return 0;
    }
    return prefs.getInt('today_count') ?? 0;
  }

  static Future<int> incrementTodayCount([int amount = 1]) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await getTodayCount();
    final newCount = current + amount;
    await prefs.setInt('today_count', newCount);
    return newCount;
  }

  static Future<int> getDailyGoal() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('daily_goal') ?? 1000;
  }

  static Future<void> setDailyGoal(int goal) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('daily_goal', goal);
  }

  // ===== Streak =====
  static Future<StreakData> getStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString('streak');
    if (json == null) return const StreakData();
    return StreakData.fromJson(jsonDecode(json));
  }

  static Future<StreakData> updateStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final streak = await getStreak();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final yesterday = DateTime.now().subtract(const Duration(days: 1))
        .toIso8601String().substring(0, 10);

    if (streak.lastCompletedDate == today) return streak;

    int newCurrent;
    if (streak.lastCompletedDate == yesterday) {
      newCurrent = streak.currentStreak + 1;
    } else {
      newCurrent = 1;
    }

    final newStreak = StreakData(
      currentStreak: newCurrent,
      longestStreak: newCurrent > streak.longestStreak ? newCurrent : streak.longestStreak,
      lastCompletedDate: today,
    );
    await prefs.setString('streak', jsonEncode(newStreak.toJson()));
    return newStreak;
  }

  static Future<StreakData> checkStreakValidity() async {
    final streak = await getStreak();
    if (streak.currentStreak == 0) return streak;
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final yesterday = DateTime.now().subtract(const Duration(days: 1))
        .toIso8601String().substring(0, 10);
    if (streak.lastCompletedDate != today && streak.lastCompletedDate != yesterday) {
      final prefs = await SharedPreferences.getInstance();
      final reset = StreakData(
        currentStreak: 0,
        longestStreak: streak.longestStreak,
        lastCompletedDate: streak.lastCompletedDate,
      );
      await prefs.setString('streak', jsonEncode(reset.toJson()));
      return reset;
    }
    return streak;
  }

  // ===== Settings =====
  static Future<bool> getHapticEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('haptic_enabled') ?? true;
  }

  static Future<void> setHapticEnabled(bool v) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('haptic_enabled', v);
  }

  static Future<bool> getNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('notif_enabled') ?? false;
  }

  static Future<void> setNotificationsEnabled(bool v) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notif_enabled', v);
  }

  static Future<String> getMorningNotifTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('morning_notif') ?? '07:00';
  }

  static Future<void> setMorningNotifTime(String t) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('morning_notif', t);
  }

  static Future<String> getEveningNotifTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('evening_notif') ?? '18:00';
  }

  static Future<void> setEveningNotifTime(String t) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('evening_notif', t);
  }

  // ===== Favorites =====
  static Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('favorites') ?? [];
  }

  static Future<void> toggleFavorite(String dhikrId) async {
    final prefs = await SharedPreferences.getInstance();
    final favs = prefs.getStringList('favorites') ?? [];
    if (favs.contains(dhikrId)) {
      favs.remove(dhikrId);
    } else {
      favs.add(dhikrId);
    }
    await prefs.setStringList('favorites', favs);
  }

  // ===== Total Count (All Time) =====
  static Future<int> getTotalCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('total_count') ?? 0;
  }

  static Future<void> incrementTotalCount([int amount = 1]) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt('total_count') ?? 0;
    await prefs.setInt('total_count', current + amount);
  }

  // ===== Ayah of the Day =====
  static Future<int> getAyahIndex() async {
    final prefs = await SharedPreferences.getInstance();
    final savedDate = prefs.getString('ayah_date');
    final today = DateTime.now().toIso8601String().substring(0, 10);
    if (savedDate != today) {
      final newIdx = DateTime.now().millisecondsSinceEpoch % 20;
      await prefs.setString('ayah_date', today);
      await prefs.setInt('ayah_index', newIdx);
      return newIdx;
    }
    return prefs.getInt('ayah_index') ?? 0;
  }

  // ===== Completed Adhkar Today =====
  static Future<List<String>> getCompletedToday() async {
    final prefs = await SharedPreferences.getInstance();
    final savedDate = prefs.getString('completed_date');
    final today = DateTime.now().toIso8601String().substring(0, 10);
    if (savedDate != today) {
      await prefs.setString('completed_date', today);
      await prefs.setStringList('completed_today', []);
      return [];
    }
    return prefs.getStringList('completed_today') ?? [];
  }

  static Future<void> markDhikrCompleted(String dhikrId) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await getCompletedToday();
    if (!list.contains(dhikrId)) {
      list.add(dhikrId);
      await prefs.setStringList('completed_today', list);
    }
  }
}
