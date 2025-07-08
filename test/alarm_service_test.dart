
import 'package:flutter_test/flutter_test.dart';
import 'package:wake_senpai/services/alarm_service.dart';
import 'package:wake_senpai/models/alarm.dart';

void main() {
  group('AlarmService', () {
    late AlarmService alarmService;

    setUp(() {
      alarmService = AlarmService();
      // Inisialisasi mock atau dependensi palsu jika diperlukan
    });

    test('scheduleAlarm menjadwalkan alarm dengan benar', () async {
      // TODO: Implementasi tes untuk scheduleAlarm
      // Pastikan alarm dijadwalkan dengan parameter yang benar
      final testAlarm = Alarm(
        id: 1,
        time: TimeOfDayCustom(hour: 10, minute: 30),
        isActive: true,
        isRepeatingDaily: false,
        soundPath: 'default.mp3',
        challengeType: 'puzzle',
      );
      // await alarmService.scheduleAlarm(testAlarm);
      // Verifikasi bahwa metode penjadwalan yang sesuai dipanggil
    });

    test('cancelAlarm membatalkan alarm dengan benar', () async {
      // TODO: Implementasi tes untuk cancelAlarm
      // Pastikan alarm dibatalkan dengan ID yang benar
      final testAlarmId = 1;
      // await alarmService.cancelAlarm(testAlarmId);
      // Verifikasi bahwa metode pembatalan yang sesuai dipanggil
    });
  });
}


