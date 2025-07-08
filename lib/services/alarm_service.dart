import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import '../models/alarm.dart';

class AlarmService {
  static AlarmService? _instance;
  static AlarmService get instance => _instance ??= AlarmService._();
  AlarmService._();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    try {
      // Initialize timezone
      tz_data.initializeTimeZones();
      
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );
      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );
      
      await _notifications.initialize(initSettings);
      
      // Request permissions for Android 13+
      await _notifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
      
      _isInitialized = true;
    } catch (e) {
      debugPrint('AlarmService initialization error: $e');
      _isInitialized = false;
    }
  }

  Future<void> scheduleAlarm(Alarm alarm) async {
    if (!_isInitialized) await init();

    try {
      await _notifications.zonedSchedule(
        alarm.id,
        'WakeSenpai Alarm',
        'Waktunya bangun! ${alarm.timeString}',
        _nextInstanceOfTime(alarm.hour, alarm.minute),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'alarm_channel',
            'Alarm Notifications',
            channelDescription: 'Notifications for WakeSenpai alarms',
            importance: Importance.max,
            priority: Priority.high,
            fullScreenIntent: true,
            category: AndroidNotificationCategory.alarm,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: alarm.isRepeatingDaily ? DateTimeComponents.time : null,
      );
    } catch (e) {
      debugPrint('Schedule alarm error: $e');
    }
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    
    return scheduledDate;
  }

  Future<void> cancelAlarm(int id) async {
    try {
      await _notifications.cancel(id);
    } catch (e) {
      debugPrint('Cancel alarm error: $e');
    }
  }
}