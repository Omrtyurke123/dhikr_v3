import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;
    tz.initializeTimeZones();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: ios);

    await _plugin.initialize(settings);
    _initialized = true;
  }

  static Future<void> requestPermissions() async {
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static Future<void> scheduleMorningReminder(String time) async {
    await _cancelById(1);
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    await _plugin.zonedSchedule(
      1,
      '🌅 أذكار الصباح',
      'لا تنسَ أذكار الصباح — ابدأ يومك بذكر الله',
      _nextInstanceOfTime(hour, minute),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'morning_channel', 'أذكار الصباح',
          channelDescription: 'تذكير بأذكار الصباح',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<void> scheduleEveningReminder(String time) async {
    await _cancelById(2);
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    await _plugin.zonedSchedule(
      2,
      '🌇 أذكار المساء',
      'حان وقت أذكار المساء — اختم يومك بذكر الله',
      _nextInstanceOfTime(hour, minute),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'evening_channel', 'أذكار المساء',
          channelDescription: 'تذكير بأذكار المساء',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<void> schedulePeriodicReminder(int hours) async {
    await _cancelById(3);
    await _plugin.periodicallyShow(
      3,
      '📿 وقت التسبيح',
      'سبّح الله وادكره في كل وقت',
      RepeatInterval.values[hours.clamp(0, 3)],
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'periodic_channel', 'تذكير التسبيح',
          channelDescription: 'تذكير دوري بالتسبيح',
          importance: Importance.defaultImportance,
          icon: '@mipmap/ic_launcher',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  static Future<void> showInstantNotification(String title, String body) async {
    await _plugin.show(
      99,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'instant_channel', 'إشعارات فورية',
          importance: Importance.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
    );
  }

  static Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  static Future<void> _cancelById(int id) async {
    await _plugin.cancel(id);
  }

  static tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}

