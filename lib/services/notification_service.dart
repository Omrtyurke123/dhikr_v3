import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;
    tz.initializeTimeZones();

    // تعيين timezone لمصر
    try {
      tz.setLocalLocation(tz.getLocation('Africa/Cairo'));
    } catch (_) {
      // استخدم UTC لو مش موجود
    }

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const settings = InitializationSettings(android: android, iOS: ios);
    await _plugin.initialize(settings);
    _initialized = true;
  }

  static Future<bool> requestPermissions() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    final granted = await android?.requestNotificationsPermission();
    return granted ?? false;
  }

  // إشعار الصباح
  static Future<void> scheduleMorningReminder(String time) async {
    await _cancelById(1);
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    await _plugin.zonedSchedule(
      1,
      '🌅 أذكار الصباح',
      'أصبحنا وأصبح الملك لله — ابدأ يومك بذكر الله',
      _nextTime(hour, minute),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'morning_channel',
          'أذكار الصباح',
          channelDescription: 'تذكير يومي بأذكار الصباح',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          styleInformation: const BigTextStyleInformation(
            'أصبحنا وأصبح الملك لله، والحمد لله — لا تنسَ أذكار الصباح',
          ),
          color: const Color(0xFF6B8F3E),
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  // إشعار المساء
  static Future<void> scheduleEveningReminder(String time) async {
    await _cancelById(2);
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    await _plugin.zonedSchedule(
      2,
      '🌇 أذكار المساء',
      'حان وقت أذكار المساء — اختم يومك بذكر الله',
      _nextTime(hour, minute),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'evening_channel',
          'أذكار المساء',
          channelDescription: 'تذكير يومي بأذكار المساء',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: const Color(0xFF6B8F3E),
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  // إشعار دوري كل X ساعات
  static Future<void> schedulePeriodicReminder(int hours) async {
    await _cancelById(3);
    if (hours <= 0) return;

    RepeatInterval interval;
    switch (hours) {
      case 1: interval = RepeatInterval.hourly; break;
      case 6: interval = RepeatInterval.sixHours; break;
      case 24: interval = RepeatInterval.daily; break;
      default: interval = RepeatInterval.hourly;
    }

    await _plugin.periodicallyShow(
      3,
      '📿 وقت التسبيح',
      'سبّح الله وادكره في كل حين — لا إله إلا الله',
      interval,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'periodic_channel',
          'تذكير التسبيح',
          channelDescription: 'تذكير دوري بالتسبيح',
          importance: Importance.defaultImportance,
          icon: '@mipmap/ic_launcher',
          color: Color(0xFF6B8F3E),
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  // إشعار فوري للاختبار
  static Future<void> showTestNotification() async {
    await _plugin.show(
      99,
      '🔔 اختبار الإشعارات',
      'الإشعارات تعمل بشكل صحيح ✅',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'test_channel',
          'إشعارات تجريبية',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: Color(0xFF6B8F3E),
        ),
      ),
    );
  }

  // إشعار إتمام الهدف اليومي
  static Future<void> showGoalCompletedNotification() async {
    await _plugin.show(
      100,
      '🎉 أحسنت! أكملت هدفك اليومي',
      'بارك الله فيك على مواظبتك على ذكر الله',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'goal_channel',
          'إتمام الهدف',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: Color(0xFFD4A843),
        ),
      ),
    );
  }

  static Future<void> cancelAll() async => await _plugin.cancelAll();
  static Future<void> _cancelById(int id) async => await _plugin.cancel(id);

  static tz.TZDateTime _nextTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var t = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (t.isBefore(now)) t = t.add(const Duration(days: 1));
    return t;
  }
}
