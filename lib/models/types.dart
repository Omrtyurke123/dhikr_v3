enum CategoryType {
  morning, evening, prayer, sleep, istighfar, tasbeeh, salawat, misc, quran, dua
}

class DhikrItem {
  final String id;
  final String arabic;
  final String transliteration;
  final String meaning;
  final int count;
  final String? source;
  final CategoryType category;
  final String? virtue;

  const DhikrItem({
    required this.id,
    required this.arabic,
    required this.transliteration,
    required this.meaning,
    required this.count,
    this.source,
    required this.category,
    this.virtue,
  });
}

class DhikrCategory {
  final String id;
  final String name;
  final String icon;
  final CategoryType type;
  final List<DhikrItem> adhkar;
  final String? description;

  const DhikrCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.type,
    required this.adhkar,
    this.description,
  });
}

class DailyChallenge {
  final String id;
  final String name;
  final String dhikrId;
  final String dhikrText;
  final int targetCount;
  int currentCount;
  final String createdAt;
  bool isCompleted;

  DailyChallenge({
    required this.id,
    required this.name,
    required this.dhikrId,
    required this.dhikrText,
    required this.targetCount,
    this.currentCount = 0,
    required this.createdAt,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id, 'name': name, 'dhikrId': dhikrId, 'dhikrText': dhikrText,
    'targetCount': targetCount, 'currentCount': currentCount,
    'createdAt': createdAt, 'isCompleted': isCompleted,
  };

  factory DailyChallenge.fromJson(Map<String, dynamic> j) => DailyChallenge(
    id: j['id'], name: j['name'], dhikrId: j['dhikrId'],
    dhikrText: j['dhikrText'], targetCount: j['targetCount'],
    currentCount: j['currentCount'] ?? 0, createdAt: j['createdAt'],
    isCompleted: j['isCompleted'] ?? false,
  );

  double get progress => targetCount > 0 ? (currentCount / targetCount).clamp(0.0, 1.0) : 0.0;
}

class StreakData {
  final int currentStreak;
  final int longestStreak;
  final String lastCompletedDate;

  const StreakData({
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastCompletedDate = '',
  });

  Map<String, dynamic> toJson() => {
    'currentStreak': currentStreak,
    'longestStreak': longestStreak,
    'lastCompletedDate': lastCompletedDate,
  };

  factory StreakData.fromJson(Map<String, dynamic> j) => StreakData(
    currentStreak: j['currentStreak'] ?? 0,
    longestStreak: j['longestStreak'] ?? 0,
    lastCompletedDate: j['lastCompletedDate'] ?? '',
  );
}

class PrayerTime {
  final String name;
  final String arabicName;
  final String time;

  const PrayerTime({required this.name, required this.arabicName, required this.time});
}

class QuranAyah {
  final int surahNumber;
  final String surahName;
  final int ayahNumber;
  final String arabic;
  final String meaning;

  const QuranAyah({
    required this.surahNumber,
    required this.surahName,
    required this.ayahNumber,
    required this.arabic,
    required this.meaning,
  });
}
