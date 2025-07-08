import 'package:flutter/material.dart';
import '../models/alarm.dart';
import '../services/database_service.dart';
import '../services/alarm_service.dart';

class AlarmViewModel extends ChangeNotifier {
  final DatabaseService _db = DatabaseService.instance;
  final AlarmService _alarmService = AlarmService.instance;

  List<Alarm> _alarms = [];
  List<Alarm> get alarms => _alarms;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  AlarmViewModel() {
    _loadAlarms();
  }

  Future<void> _loadAlarms() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _db.init();
      await _alarmService.init();
      _alarms = _db.getAlarms();
    } catch (e) {
      // Handle error loading alarms
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addAlarm({
    required int hour,
    required int minute,
    required bool isRepeatingDaily,
    required String soundPath,
    required String challengeType,
  }) async {
    final alarm = Alarm(
      id: DateTime.now().millisecondsSinceEpoch,
      hour: hour,
      minute: minute,
      isActive: true,
      isRepeatingDaily: isRepeatingDaily,
      soundPath: soundPath,
      challengeType: challengeType,
    );

    _alarms.add(alarm);
    await _db.saveAlarm(alarm);
    await _alarmService.scheduleAlarm(alarm);
    notifyListeners();
  }

  Future<void> updateAlarm(Alarm alarm) async {
    await _db.saveAlarm(alarm);
    if (alarm.isActive) {
      await _alarmService.scheduleAlarm(alarm);
    } else {
      await _alarmService.cancelAlarm(alarm.id);
    }
    notifyListeners();
  }

  Future<void> deleteAlarm(int id) async {
    _alarms.removeWhere((alarm) => alarm.id == id);
    await _db.deleteAlarm(id);
    await _alarmService.cancelAlarm(id);
    notifyListeners();
  }

  void toggleAlarm(Alarm alarm) {
    alarm.isActive = !alarm.isActive;
    updateAlarm(alarm);
  }
}