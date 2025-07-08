import 'package:flutter/material.dart';
import 'package:wake_senpai/models/alarm.dart';
import 'package:wake_senpai/services/alarm_service.dart';
import 'package:wake_senpai/services/local_db_service.dart';

class AlarmViewModel extends ChangeNotifier {
  final AlarmService _alarmService = AlarmService.instance;
  final LocalDbService _localDbService = LocalDbService.instance;

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
      await _localDbService.init();
      await _alarmService.init();
      _alarms = _localDbService.getAlarms();
    } catch (e) {
      print('Error loading alarms: $e');
      _alarms = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addAlarm(TimeOfDayCustom time, bool isRepeatingDaily, String soundPath, String challengeType) async {
    try {
      final newAlarm = Alarm(
        id: DateTime.now().millisecondsSinceEpoch,
        time: time,
        isActive: true,
        isRepeatingDaily: isRepeatingDaily,
        soundPath: soundPath,
        challengeType: challengeType,
      );
      
      _alarms.add(newAlarm);
      await _localDbService.saveAlarm(newAlarm);
      await _alarmService.scheduleAlarm(newAlarm);
      notifyListeners();
    } catch (e) {
      print('Error adding alarm: $e');
    }
  }

  Future<void> updateAlarm(Alarm alarm) async {
    try {
      await _localDbService.saveAlarm(alarm);
      if (alarm.isActive) {
        await _alarmService.scheduleAlarm(alarm);
      } else {
        await _alarmService.cancelAlarm(alarm.id);
      }
      notifyListeners();
    } catch (e) {
      print('Error updating alarm: $e');
    }
  }

  Future<void> deleteAlarm(int id) async {
    try {
      _alarms.removeWhere((alarm) => alarm.id == id);
      await _localDbService.deleteAlarm(id);
      await _alarmService.cancelAlarm(id);
      notifyListeners();
    } catch (e) {
      print('Error deleting alarm: $e');
    }
  }

  void toggleAlarm(Alarm alarm) {
    alarm.isActive = !alarm.isActive;
    updateAlarm(alarm);
  }

  Future<void> refresh() async {
    await _loadAlarms();
  }
}