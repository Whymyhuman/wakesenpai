import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:wake_senpai/models/alarm.dart';
import 'package:wake_senpai/views/wake_screen.dart';
import 'package:flutter/material.dart';
import 'package:wake_senpai/services/local_db_service.dart';

// Entry point untuk alarm yang dipicu oleh AndroidAlarmManager
@pragma('vm:entry-point')
void alarmCallback(int id) async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    final localDbService = LocalDbService.instance;
    await localDbService.init();

    final alarm = localDbService.getAlarmById(id);

    if (alarm != null) {
      runApp(MaterialApp(
        home: WakeScreen(alarm: alarm),
        debugShowCheckedModeBanner: false,
      ));
    } else {
      print('Alarm dengan ID $id tidak ditemukan.');
    }
  } catch (e) {
    print('Error in alarm callback: $e');
  }
}

class AlarmService {
  static AlarmService? _instance;
  static AlarmService get instance => _instance ??= AlarmService._();
  AlarmService._();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = 
      FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    try {
      // Inisialisasi plugin notifikasi lokal
      const AndroidInitializationSettings initializationSettingsAndroid = 
          AndroidInitializationSettings('app_icon');
      const InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
      );
      await flutterLocalNotificationsPlugin.initialize(initializationSettings);

      // Inisialisasi Android Alarm Manager Plus
      await AndroidAlarmManager.initialize();
      
      _isInitialized = true;
    } catch (e) {
      print('Error initializing AlarmService: $e');
    }
  }

  Future<void> scheduleAlarm(Alarm alarm) async {
    if (!_isInitialized) await init();

    try {
      final now = DateTime.now();
      var scheduledTime = DateTime(now.year, now.month, now.day, alarm.time.hour, alarm.time.minute);
      if (scheduledTime.isBefore(now)) {
        scheduledTime = scheduledTime.add(const Duration(days: 1));
      }

      await AndroidAlarmManager.oneAt(
        scheduledTime,
        alarm.id,
        alarmCallback,
        exact: true,
        wakeup: true,
        rescheduleOnRestart: true,
      );

      // Tampilkan notifikasi sebagai konfirmasi
      await _showNotification(alarm, scheduledTime);
    } catch (e) {
      print('Error scheduling alarm: $e');
    }
  }

  Future<void> _showNotification(Alarm alarm, DateTime scheduledTime) async {
    try {
      await flutterLocalNotificationsPlugin.show(
        alarm.id,
        'Alarm WakeSenpai',
        'Alarm akan berbunyi pada ${alarm.time}',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'alarm_channel',
            'Saluran Alarm',
            channelDescription: 'Saluran untuk notifikasi alarm WakeSenpai',
            importance: Importance.max,
            priority: Priority.high,
            fullScreenIntent: true,
          ),
        ),
      );
    } catch (e) {
      print('Error showing notification: $e');
    }
  }

  Future<void> cancelAlarm(int id) async {
    try {
      await AndroidAlarmManager.cancel(id);
      await flutterLocalNotificationsPlugin.cancel(id);
    } catch (e) {
      print('Error canceling alarm: $e');
    }
  }
}