import 'package:flutter/material.dart';
import 'package:wake_senpai/services/habit_predictor.dart';

class HabitPredictorViewModel extends ChangeNotifier {
  final HabitPredictorService _habitPredictorService = HabitPredictorService();
  int _predictedSnoozeTime = 0;

  int get predictedSnoozeTime => _predictedSnoozeTime;

  HabitPredictorViewModel() {
    _habitPredictorService.loadModel();
  }

  Future<void> predictSnoozeTime() async {
    _predictedSnoozeTime = await _habitPredictorService.prediksiWaktuTundaSelanjutnya();
    notifyListeners();
  }

  @override
  void dispose() {
    _habitPredictorService.dispose();
    super.dispose();
  }
}


