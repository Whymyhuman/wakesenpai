import 'package:flutter/material.dart';
import 'package:wake_senpai/models/alarm.dart';
import 'package:wake_senpai/services/alarm_service.dart';
import 'package:wake_senpai/services/local_db_service.dart';

class AlarmViewModel extends ChangeNotifier {
  final AlarmService _alarmService = AlarmService();
  final LocalDbService _localDbService = LocalDbService();

  List<Alarm> _alarms = [];
  List<Alarm> get alarms => _alarms;

  AlarmViewModel() {
    _loadAlarms();
  }

  Future<void> _loadAlarms() async {
    await _localDbService.init();
    _alarms = _localDbService.getAlarms();
    notifyListeners();
  }

  Future<void> addAlarm(TimeOfDay time, bool isRepeatingDaily, String soundPath, String challengeType) async {
    final newAlarm = Alarm(
      id: DateTime.now().millisecondsSinceEpoch, // ID unik
      time: time,
      isActive: true,
      isRepeatingDaily: isRepeatingDaily,
      soundPath: soundPath,
      challengeType: challengeType,
    );
    _alarms.add(newAlarm);
    await _localDbService.saveAlarm(newAlarm);
    _alarmService.scheduleAlarm(newAlarm);
    notifyListeners();
  }

  Future<void> updateAlarm(Alarm alarm) async {
    await _localDbService.saveAlarm(alarm);
    if (alarm.isActive) {
      _alarmService.scheduleAlarm(alarm);
    } else {
      _alarmService.cancelAlarm(alarm.id);
    }
    notifyListeners();
  }

  Future<void> deleteAlarm(int id) async {
    _alarms.removeWhere((alarm) => alarm.id == id);
    await _localDbService.deleteAlarm(id);
    _alarmService.cancelAlarm(id);
    notifyListeners();
  }

  void toggleAlarm(Alarm alarm) {
    alarm.isActive = !alarm.isActive;
    updateAlarm(alarm);
  }
}


