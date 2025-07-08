import 'package:hive_flutter/hive_flutter.dart';
import '../models/alarm.dart';
import '../models/user_stats.dart';

class DatabaseService {
  static DatabaseService? _instance;
  static DatabaseService get instance => _instance ??= DatabaseService._();
  DatabaseService._();

  Box<Alarm>? _alarmBox;
  Box<UserStats>? _userStatsBox;
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    try {
      await Hive.initFlutter();
      
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(AlarmAdapter());
      }
      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(UserStatsAdapter());
      }

      _alarmBox = await Hive.openBox<Alarm>('alarms');
      _userStatsBox = await Hive.openBox<UserStats>('user_stats');
      
      _isInitialized = true;
    } catch (e) {
      // Handle error silently or use proper logging
      _isInitialized = false;
    }
  }

  // Alarm operations
  List<Alarm> getAlarms() {
    return _alarmBox?.values.toList() ?? [];
  }

  Alarm? getAlarmById(int id) {
    return _alarmBox?.get(id);
  }

  Future<void> saveAlarm(Alarm alarm) async {
    await _alarmBox?.put(alarm.id, alarm);
  }

  Future<void> deleteAlarm(int id) async {
    await _alarmBox?.delete(id);
  }

  // User stats operations
  UserStats getUserStats() {
    return _userStatsBox?.get('user_stats') ?? 
           UserStats(xp: 0, unlockedIllustrations: [], unlockedSounds: []);
  }

  Future<void> saveUserStats(UserStats userStats) async {
    await _userStatsBox?.put('user_stats', userStats);
  }

  Future<void> close() async {
    await _alarmBox?.close();
    await _userStatsBox?.close();
    _isInitialized = false;
  }
}