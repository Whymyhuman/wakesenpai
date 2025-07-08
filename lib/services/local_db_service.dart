import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wake_senpai/models/alarm.dart';
import 'package:wake_senpai/models/user_stats.dart';


class LocalDbService {
  late Box<Alarm> _alarmBox;
  late Box<UserStats> _userStatsBox;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(AlarmAdapter());
    Hive.registerAdapter(TimeOfDayCustomAdapter());
    Hive.registerAdapter(UserStatsAdapter());

    String? encryptionKeyString = await _secureStorage.read(key: 'hive_encryption_key');
    if (encryptionKeyString == null) {
      final key = Hive.generateSecureKey();
      encryptionKeyString = base64UrlEncode(key);
      await _secureStorage.write(key: 'hive_encryption_key', value: encryptionKeyString);
    }
    final encryptionKey = base64UrlDecode(encryptionKeyString);

    _alarmBox = await Hive.openBox<Alarm>('alarms', encryptionCipher: HiveAesCipher(encryptionKey));
    _userStatsBox = await Hive.openBox<UserStats>('user_stats', encryptionCipher: HiveAesCipher(encryptionKey));
  }

  List<Alarm> getAlarms() {
    return _alarmBox.values.toList();
  }

  Alarm? getAlarmById(int id) {
    return _alarmBox.get(id);
  }

  Future<void> saveAlarm(Alarm alarm) async {
    await _alarmBox.put(alarm.id, alarm);
  }

  Future<void> deleteAlarm(int id) async {
    await _alarmBox.delete(id);
  }

  UserStats getUserStats() {
    return _userStatsBox.get('user_stats_key') ?? UserStats(xp: 0, unlockedIllustrations: [], unlockedSounds: []);
  }

  Future<void> saveUserStats(UserStats userStats) async {
    await _userStatsBox.put('user_stats_key', userStats);
  }
}



