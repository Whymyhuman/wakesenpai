class BackgroundService {
  String getDynamicBackground() {
    final now = DateTime.now();
    // Contoh sederhana: pagi (6-18) dan malam (18-6)
    if (now.hour >= 6 && now.hour < 18) {
      return 'assets/images/senpai_chibi_01.png';
    } else {
      return 'assets/images/senpai_chibi_02.png';
    }
  }
}