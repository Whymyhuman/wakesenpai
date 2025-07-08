import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/alarm.dart';
import '../models/user_stats.dart';

class LocalDbService {
  static LocalDbService? _instance;
  static LocalDbService get instance => _instance ??= LocalDbService._();
  LocalDbService._();

  Box<Alarm>? _alarmBox;
  Box<UserStats>? _userStatsBox;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    try {
      await Hive.initFlutter();
      
      // Register adapters only if not already registered
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(AlarmAdapter());
      }
      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(UserStatsAdapter());
      }

      // Try to use encryption if possible
      try {
        String? encryptionKeyString = await _secureStorage.read(key: 'hive_encryption_key');
        if (encryptionKeyString == null) {
          final key = Hive.generateSecureKey();
          encryptionKeyString = base64UrlEncode(key);
          await _secureStorage.write(key: 'hive_encryption_key', value: encryptionKeyString);
        }
        final encryptionKey = base64UrlDecode(encryptionKeyString);

        _alarmBox = await Hive.openBox<Alarm>('alarms', encryptionCipher: HiveAesCipher(encryptionKey));
        _userStatsBox = await Hive.openBox<UserStats>('user_stats', encryptionCipher: HiveAesCipher(encryptionKey));
      } catch (e) {
        // Fallback to non-encrypted boxes
        debugPrint('Encryption failed, using non-encrypted storage: $e');
        _alarmBox = await Hive.openBox<Alarm>('alarms');
        _userStatsBox = await Hive.openBox<UserStats>('user_stats');
      }
      
      _isInitialized = true;
    } catch (e) {
      debugPrint('LocalDbService initialization error: $e');
      _isInitialized = false;
    }
  }

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

  UserStats getUserStats() {
    if (!_isInitialized || _userStatsBox == null) {
      return UserStats(xp: 0, unlockedIllustrations: [], unlockedSounds: []);
    }
    return _userStatsBox!.get('user_stats_key') ?? 
           UserStats(xp: 0, unlockedIllustrations: [], unlockedSounds: []);
  }

  Future<void> saveUserStats(UserStats userStats) async {
    if (!_isInitialized || _userStatsBox == null) return;
    try {
      await _userStatsBox!.put('user_stats_key', userStats);
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
      debugPrint('LocalDbService close error: $e');
    }
  }
}