import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wake_senpai/viewmodels/alarm_viewmodel.dart';
import 'package:wake_senpai/views/home_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wake_senpai/models/alarm.dart';
import 'package:wake_senpai/models/user_stats.dart';
import 'package:wake_senpai/services/local_db_service.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Initialize notifications
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    
    // Initialize Hive
    await Hive.initFlutter();
    
    // Register adapters only if not already registered
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(AlarmAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(TimeOfDayCustomAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(UserStatsAdapter());
    }
    
    // Initialize Android Alarm Manager
    await AndroidAlarmManager.initialize();
    
    runApp(const MyApp());
  } catch (e) {
    print('Error during initialization: $e');
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AlarmViewModel()),
      ],
      child: MaterialApp(
        title: 'WakeSenpai',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}