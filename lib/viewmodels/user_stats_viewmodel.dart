import 'package:flutter/material.dart';
import '../models/user_stats.dart';
import '../services/local_db_service.dart';

class UserStatsViewModel extends ChangeNotifier {
  final LocalDbService _localDbService = LocalDbService.instance;
  late UserStats _userStats;

  UserStats get userStats => _userStats;

  UserStatsViewModel() {
    _loadUserStats();
  }

  Future<void> _loadUserStats() async {
    await _localDbService.init(); // Pastikan inisialisasi sudah dilakukan
    _userStats = _localDbService.getUserStats();
    notifyListeners();
  }

  Future<void> addXp(int amount) async {
    _userStats.xp += amount;
    await _localDbService.saveUserStats(_userStats);
    notifyListeners();
  }

  Future<void> unlockIllustration(String illustrationPath) async {
    if (!_userStats.unlockedIllustrations.contains(illustrationPath)) {
      _userStats.unlockedIllustrations.add(illustrationPath);
      await _localDbService.saveUserStats(_userStats);
      notifyListeners();
    }
  }

  Future<void> unlockSound(String soundPath) async {
    if (!_userStats.unlockedSounds.contains(soundPath)) {
      _userStats.unlockedSounds.add(soundPath);
      await _localDbService.saveUserStats(_userStats);
      notifyListeners();
    }
  }
}


