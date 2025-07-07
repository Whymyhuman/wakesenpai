import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:wake_senpai/models/alarm.dart';
import 'package:wake_senpai/views/puzzle_challenge_screen.dart';
import 'package:wake_senpai/views/gesture_challenge_screen.dart';
import 'package:wake_senpai/services/background_service.dart';

class WakeScreen extends StatefulWidget {
  final Alarm alarm;

  const WakeScreen({super.key, required this.alarm});

  @override
  State<WakeScreen> createState() => _WakeScreenState();
}

class _WakeScreenState extends State<WakeScreen> {
  late AudioPlayer _audioPlayer;
  late BackgroundService _backgroundService;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _backgroundService = BackgroundService();
    _playAlarmSound();
  }

  Future<void> _playAlarmSound() async {
    try {
      await _audioPlayer.setAsset('assets/audio/${widget.alarm.soundPath}');
      _audioPlayer.play();
    } catch (e) {
      print('Error playing audio: $e');
      // Handle error, e.g., play a default sound or show a message
    }
  }

  void _stopAlarm() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
    // Navigasi ke layar tantangan
    if (widget.alarm.challengeType == 'puzzle') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PuzzleChallengeScreen(
            onChallengeCompleted: () {
              // Logika setelah tantangan selesai
              Navigator.pop(context); // Kembali dari WakeScreen
            },
          ),
        ),
      );
    } else if (widget.alarm.challengeType == 'gesture') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GestureChallengeScreen(
            onChallengeCompleted: () {
              // Logika setelah tantangan selesai
              Navigator.pop(context); // Kembali dari WakeScreen
            },
          ),
        ),
      );
    } else {
      // Jika tidak ada tantangan, langsung kembali
      Navigator.pop(context);
    }
  }

  void _snoozeAlarm() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
    // TODO: Implementasi logika tunda alarm (misal: menjadwalkan ulang alarm setelah beberapa menit)
    Navigator.pop(context); // Kembali ke layar sebelumnya
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(_backgroundService.getDynamicBackground()),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Tampilkan ilustrasi karakter anime
              Image.asset(
                'assets/images/character_illustration.png', // Placeholder
                height: 200,
              ),
              const SizedBox(height: 50),
              const Text(
                'Waktunya Bangun!',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _stopAlarm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    ),
                    child: const Text(
                      'BANGUN',
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _snoozeAlarm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    ),
                    child: const Text(
                      'TUNGGU',
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


