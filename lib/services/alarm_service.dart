import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/alarm.dart';

class AlarmService {
  static AlarmService? _instance;
  static AlarmService get instance => _instance ??= AlarmService._();
  AlarmService._();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);
    
    await _notifications.initialize(initSettings);
    _isInitialized = true;
  }

  Future<void> scheduleAlarm(Alarm alarm) async {
    if (!_isInitialized) await init();

    final now = DateTime.now();
    var scheduledTime = DateTime(now.year, now.month, now.day, alarm.hour, alarm.minute);
    
    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    await _notifications.show(
      alarm.id,
      'WakeSenpai Alarm',
      'Alarm dijadwalkan untuk ${alarm.timeString}',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'alarm_channel',
          'Alarm Notifications',
          channelDescription: 'Notifications for WakeSenpai alarms',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }

  Future<void> cancelAlarm(int id) async {
    await _notifications.cancel(id);
  }
}