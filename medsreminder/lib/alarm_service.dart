import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AlarmService {
  static final _notifier = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _notifier.initialize(settings);
  }

  static Future<void> showAlarmNow(String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      'alarm_channel',
      'Medication Alarm',
      importance: Importance.max,
      priority: Priority.high,
    );
    const details = NotificationDetails(android: androidDetails);

    await _notifier.show(0, title, body, details);
  }

  static Future<void> cancelAll() async => await _notifier.cancelAll();
}
