
import 'package:flutter_test/flutter_test.dart';
import 'package:wake_senpai/services/local_db_service.dart';
import 'package:wake_senpai/models/alarm.dart';
import 'package:wake_senpai/models/user_stats.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

void main() {
  group('LocalDbService', () {
    late LocalDbService localDbService;
    late Directory tempDir;

    setUpAll(() async {
      // Inisialisasi Hive untuk pengujian
      tempDir = await getTemporaryDirectory();
      Hive.init(tempDir.path);
      Hive.registerAdapter(AlarmAdapter());
      Hive.registerAdapter(TimeOfDayAdapter());
      Hive.registerAdapter(UserStatsAdapter());
    });

    setUp(() async {
      localDbService = LocalDbService();
      await localDbService.init();
    });

    tearDown(() async {
      await Hive.deleteFromDisk();
    });

    test('getAlarms mengembalikan daftar alarm yang benar', () async {
      // TODO: Implementasi tes untuk getAlarms
      final alarm1 = Alarm(
        id: 1,
        time: TimeOfDay(hour: 8, minute: 0),
        isActive: true,
        isRepeatingDaily: false,
        soundPath: 'sound1.mp3',
        challengeType: 'puzzle',
      );
      await localDbService.saveAlarm(alarm1);

      final alarms = localDbService.getAlarms();
      expect(alarms.length, 1);
      expect(alarms[0].id, alarm1.id);
    });

    test('saveAlarm menyimpan alarm dengan benar', () async {
      // TODO: Implementasi tes untuk saveAlarm
      final alarm = Alarm(
        id: 2,
        time: TimeOfDay(hour: 9, minute: 30),
        isActive: true,
        isRepeatingDaily: true,
        soundPath: 'sound2.mp3',
        challengeType: 'gesture',
      );
      await localDbService.saveAlarm(alarm);

      final retrievedAlarm = localDbService.getAlarmById(2);
      expect(retrievedAlarm?.id, alarm.id);
    });

    test('deleteAlarm menghapus alarm dengan benar', () async {
      // TODO: Implementasi tes untuk deleteAlarm
      final alarm = Alarm(
        id: 3,
        time: TimeOfDay(hour: 10, minute: 0),
        isActive: false,
        isRepeatingDaily: false,
        soundPath: 'sound3.mp3',
        challengeType: 'puzzle',
      );
      await localDbService.saveAlarm(alarm);
      await localDbService.deleteAlarm(3);

      final retrievedAlarm = localDbService.getAlarmById(3);
      expect(retrievedAlarm, isNull);
    });

    test('getUserStats mengembalikan statistik pengguna yang benar', () async {
      // TODO: Implementasi tes untuk getUserStats
      final userStats = localDbService.getUserStats();
      expect(userStats.xp, 0);
      expect(userStats.unlockedIllustrations, isEmpty);
    });

    test('saveUserStats menyimpan statistik pengguna dengan benar', () async {
      // TODO: Implementasi tes untuk saveUserStats
      final userStats = UserStats(
        xp: 100,
        unlockedIllustrations: ['ill1.png'],
        unlockedSounds: ['sfx1.mp3'],
      );
      await localDbService.saveUserStats(userStats);

      final retrievedStats = localDbService.getUserStats();
      expect(retrievedStats.xp, 100);
      expect(retrievedStats.unlockedIllustrations, contains('ill1.png'));
    });
  });
}


