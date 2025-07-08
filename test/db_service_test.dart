import 'package:flutter_test/flutter_test.dart';
import 'package:wake_senpai/services/database_service.dart';
import 'package:wake_senpai/models/alarm.dart';
import 'package:wake_senpai/models/user_stats.dart';

void main() {
  group('DatabaseService', () {
    late DatabaseService databaseService;

    setUp(() async {
      databaseService = DatabaseService.instance;
      await databaseService.init();
    });

    test('getAlarms mengembalikan daftar alarm yang benar', () async {
      final alarm1 = Alarm(
        id: 1,
        hour: 8,
        minute: 0,
        isActive: true,
        isRepeatingDaily: false,
        soundPath: 'sound1.mp3',
        challengeType: 'puzzle',
      );
      await databaseService.saveAlarm(alarm1);

      final alarms = databaseService.getAlarms();
      expect(alarms.length, greaterThanOrEqualTo(1));
      
      final savedAlarm = alarms.firstWhere((a) => a.id == alarm1.id);
      expect(savedAlarm.id, alarm1.id);
      expect(savedAlarm.hour, alarm1.hour);
      expect(savedAlarm.minute, alarm1.minute);
    });

    test('saveAlarm menyimpan alarm dengan benar', () async {
      final alarm = Alarm(
        id: 2,
        hour: 9,
        minute: 30,
        isActive: true,
        isRepeatingDaily: true,
        soundPath: 'sound2.mp3',
        challengeType: 'gesture',
      );
      await databaseService.saveAlarm(alarm);

      final retrievedAlarm = databaseService.getAlarmById(2);
      expect(retrievedAlarm?.id, alarm.id);
      expect(retrievedAlarm?.hour, alarm.hour);
      expect(retrievedAlarm?.minute, alarm.minute);
    });

    test('deleteAlarm menghapus alarm dengan benar', () async {
      final alarm = Alarm(
        id: 3,
        hour: 10,
        minute: 0,
        isActive: false,
        isRepeatingDaily: false,
        soundPath: 'sound3.mp3',
        challengeType: 'puzzle',
      );
      await databaseService.saveAlarm(alarm);
      await databaseService.deleteAlarm(3);

      final retrievedAlarm = databaseService.getAlarmById(3);
      expect(retrievedAlarm, isNull);
    });

    test('getUserStats mengembalikan statistik pengguna yang benar', () async {
      final userStats = databaseService.getUserStats();
      expect(userStats.xp, 0);
      expect(userStats.unlockedIllustrations, isEmpty);
    });

    test('saveUserStats menyimpan statistik pengguna dengan benar', () async {
      final userStats = UserStats(
        xp: 100,
        unlockedIllustrations: ['ill1.png'],
        unlockedSounds: ['sfx1.mp3'],
      );
      await databaseService.saveUserStats(userStats);

      final retrievedStats = databaseService.getUserStats();
      expect(retrievedStats.xp, 100);
      expect(retrievedStats.unlockedIllustrations, contains('ill1.png'));
    });
  });
}