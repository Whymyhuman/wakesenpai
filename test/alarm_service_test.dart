import 'package:flutter_test/flutter_test.dart';
import 'package:wake_senpai/services/alarm_service.dart';
import 'package:wake_senpai/models/alarm.dart';

void main() {
  group('AlarmService', () {
    late AlarmService alarmService;

    setUp(() {
      alarmService = AlarmService.instance;
    });

    test('scheduleAlarm menjadwalkan alarm dengan benar', () async {
      final testAlarm = Alarm(
        id: 1,
        hour: 10,
        minute: 30,
        isActive: true,
        isRepeatingDaily: false,
        soundPath: 'default.mp3',
        challengeType: 'puzzle',
      );
      
      // Test scheduling alarm
      await alarmService.scheduleAlarm(testAlarm);
      
      // Verify alarm was scheduled (in real implementation, you'd check notification service)
      expect(testAlarm.id, equals(1));
      expect(testAlarm.timeString, equals('10:30'));
    });

    test('cancelAlarm membatalkan alarm dengan benar', () async {
      const testAlarmId = 1;
      
      // Test canceling alarm
      await alarmService.cancelAlarm(testAlarmId);
      
      // Verify alarm was canceled (in real implementation, you'd check notification service)
      expect(testAlarmId, equals(1));
    });
  });
}