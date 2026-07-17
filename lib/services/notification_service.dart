import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;
    tz.initializeTimeZones();
    try {
      tz.setLocalLocation(tz.getLocation('Africa/Cairo'));
    } catch (_) {}

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    await _plugin.initialize(const InitializationSettings(android: android, iOS: ios));
    _initialized = true;
  }

  static Future<bool> requestPermissions() async {
    final android = _plugin.resolvePlatformSpecificImplementation
        AndroidFlutterLocalNotificationsPlugin>();
    final granted = await android?.requestNotificationsPermission();
    return granted ?? false;
  }

  static Future<void> scheduleMorningReminder(String time) async {
    await _cancelById(1);
    final parts = time.split(':');
    await _plugin.zonedSchedule(
      1,
      '?? √–ﬂ«— «·’»«Õ',
      '«»œ√ ÌÊ„ﬂ »–ﬂ— «··Â ó ·«  ‰”Û √–ﬂ«— «·’»«Õ',
      _nextTime(int.parse(parts[0]), int.parse(parts[1])),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'morning_channel', '√–ﬂ«— «·’»«Õ',
          channelDescription: ' –ﬂÌ— ÌÊ„Ì »√–ﬂ«— «·’»«Õ',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<void> scheduleEveningReminder(String time) async {
    await _cancelById(2);
    final parts = time.split(':');
    await _plugin.zonedSchedule(
      2,
      '?? √–ﬂ«— «·„”«¡',
      'Õ«‰ Êﬁ  √–ﬂ«— «·„”«¡ ó «Œ „ ÌÊ„ﬂ »–ﬂ— «··Â',
      _nextTime(int.parse(parts[0]), int.parse(parts[1])),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'evening_channel', '√–ﬂ«— «·„”«¡',
          channelDescription: ' –ﬂÌ— ÌÊ„Ì »√–ﬂ«— «·„”«¡',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<void> showTestNotification() async {
    await _plugin.show(
      99,
      '?? «Œ »«— «·≈‘⁄«—« ',
      '«·≈‘⁄«—«   ⁄„· »‘ﬂ· ’ÕÌÕ ?',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'test_channel', '≈‘⁄«—«   Ã—Ì»Ì…',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
    );
  }

  static Future<void> showGoalCompletedNotification() async {
    await _plugin.show(
      100,
      '?? √Õ”‰ ! √ﬂ„·  Âœ›ﬂ «·ÌÊ„Ì',
      '»«—ﬂ «··Â ›Ìﬂ ⁄·Ï „Ê«Ÿ» ﬂ ⁄·Ï –ﬂ— «··Â',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'goal_channel', '≈ „«„ «·Âœ›',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
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
