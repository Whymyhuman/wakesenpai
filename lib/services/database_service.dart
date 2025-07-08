import 'package:flutter/foundation.dart';
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
      debugPrint('Database initialization error: $e');
      _isInitialized = false;
    }
  }

  // Alarm operations
  List<Alarm> getAlarms() {
    if (!_isInitialized || _alarmBox == null) return [];
    return _alarmBox!.values.toList();
  }

  Alarm? getAlarmById(int id) {
    if (!_isInitialized || _alarmBox == null) return null;
    return _alarmBox!.get(id);
  }

  Future<void> saveAlarm(Alarm alarm) async {
    if (!_isInitialized || _alarmBox == null) return;
    try {
      await _alarmBox!.put(alarm.id, alarm);
    } catch (e) {
      debugPrint('Save alarm error: $e');
    }
  }

  Future<void> deleteAlarm(int id) async {
    if (!_isInitialized || _alarmBox == null) return;
    try {
      await _alarmBox!.delete(id);
    } catch (e) {
      debugPrint('Delete alarm error: $e');
    }
  }

  // User stats operations
  UserStats getUserStats() {
    if (!_isInitialized || _userStatsBox == null) {
      return UserStats(xp: 0, unlockedIllustrations: [], unlockedSounds: []);
    }
    return _userStatsBox!.get('user_stats') ?? 
           UserStats(xp: 0, unlockedIllustrations: [], unlockedSounds: []);
  }

  Future<void> saveUserStats(UserStats userStats) async {
    if (!_isInitialized || _userStatsBox == null) return;
    try {
      await _userStatsBox!.put('user_stats', userStats);
    } catch (e) {
      debugPrint('Save user stats error: $e');
    }
  }

  Future<void> close() async {
    try {
      await _alarmBox?.close();
      await _userStatsBox?.close();
      _isInitialized = false;
    } catch (e) {
      debugPrint('Database close error: $e');
    }
  }
}