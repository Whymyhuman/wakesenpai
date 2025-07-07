import 'package:flutter/material.dart';

class BackgroundService {
  String getDynamicBackground() {
    final now = DateTime.now();
    // Contoh sederhana: pagi (6-18) dan malam (18-6)
    if (now.hour >= 6 && now.hour < 18) {
      return 'assets/images/morning_background.png'; // Koridor sekolah
    } else {
      return 'assets/images/night_background.png'; // Kota neon
    }
  }
}


