import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wake_senpai/viewmodels/alarm_viewmodel.dart';
import 'package:wake_senpai/views/home_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wake_senpai/models/alarm.dart';
import 'package:wake_senpai/services/local_db_service.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:wake_senpai/services/alarm_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(AlarmAdapter());
  Hive.registerAdapter(TimeOfDayAdapter());
  await AndroidAlarmManager.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AlarmViewModel()),
        // Tambahkan ViewModel lain di sini
      ],
      child: MaterialApp(
        title: 'WakeSenpai',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomeScreen(),
      ),
    );
  }
}


