import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:wake_senpai/models/alarm.dart';
import 'package:wake_senpai/views/wake_screen.dart';
import 'package:flutter/material.dart';
import 'package:wake_senpai/services/local_db_service.dart'; // Import LocalDbService

// Entry point untuk alarm yang dipicu oleh AndroidAlarmManager
@pragma('vm:entry-point')
void alarmCallback(int id) async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inisialisasi LocalDbService untuk mengambil data alarm
  final localDbService = LocalDbService();
  await localDbService.init();

  final alarm = localDbService.getAlarmById(id); // Asumsi ada method getAlarmById

  if (alarm != null) {
    runApp(MaterialApp(home: WakeScreen(alarm: alarm)));
  } else {
    print('Alarm dengan ID $id tidak ditemukan.');
  }
}

class AlarmService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Inisialisasi plugin notifikasi lokal
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Inisialisasi Android Alarm Manager Plus
    await AndroidAlarmManager.initialize();
  }

  Future<void> scheduleAlarm(Alarm alarm) async {
    final now = DateTime.now();
    var scheduledTime = DateTime(now.year, now.month, now.day, alarm.time.hour, alarm.time.minute);
    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    await AndroidAlarmManager.oneAt(
      scheduledTime,
      alarm.id,
      alarmCallback, // Panggil alarmCallback dengan ID alarm
      exact: true,
      wakeup: true,
      rescheduleOnRestart: true,
    );

    // Tampilkan notifikasi sebagai fallback atau konfirmasi
    await flutterLocalNotificationsPlugin.show(
      alarm.id,
      'Alarm WakeSenpai',
      'Alarm akan berbunyi pada ${alarm.time.hour.toString().padLeft(2, '0')}:${alarm.time.minute.toString().padLeft(2, '0')}',
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
  }

  Future<void> cancelAlarm(int id) async {
    await AndroidAlarmManager.cancel(id);
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}


