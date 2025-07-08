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
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _backgroundService = BackgroundService();
    _playAlarmSound();
  }

  Future<void> _playAlarmSound() async {
    try {
      setState(() {
        _isPlaying = true;
      });
      
      // Coba putar file audio yang ditentukan
      try {
        await _audioPlayer.setAsset('assets/audio/${widget.alarm.soundPath}');
        await _audioPlayer.play();
      } catch (e) {
        print('Audio file not found: ${widget.alarm.soundPath}');
        // Fallback: tidak ada suara, hanya visual
      }
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  void _stopAlarm() {
    if (_isPlaying) {
      _audioPlayer.stop();
      setState(() {
        _isPlaying = false;
      });
    }
    
    // Navigasi ke layar tantangan
    if (widget.alarm.challengeType == 'puzzle') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PuzzleChallengeScreen(
            onChallengeCompleted: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ),
      );
    } else if (widget.alarm.challengeType == 'gesture') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => GestureChallengeScreen(
            onChallengeCompleted: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ),
      );
    } else {
      // Jika tidak ada tantangan, langsung kembali
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  void _snoozeAlarm() {
    if (_isPlaying) {
      _audioPlayer.stop();
      setState(() {
        _isPlaying = false;
      });
    }
    
    // TODO: Implementasi logika tunda alarm
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Alarm ditunda 5 menit')),
    );
    
    Navigator.of(context).popUntil((route) => route.isFirst);
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
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade800,
              Colors.blue.shade400,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Tampilkan ilustrasi karakter anime
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Image.asset(
                    _backgroundService.getDynamicBackground(),
                    height: 200,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: const Icon(
                          Icons.alarm,
                          size: 80,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 50),
                const Text(
                  'Waktunya Bangun!',
                  style: TextStyle(
                    fontSize: 36, 
                    fontWeight: FontWeight.bold, 
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  widget.alarm.time.toString(),
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _stopAlarm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check, size: 30),
                          SizedBox(height: 5),
                          Text(
                            'BANGUN',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _snoozeAlarm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.snooze, size: 30),
                          SizedBox(height: 5),
                          Text(
                            'TUNDA',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                if (_isPlaying)
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.volume_up, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        'Alarm sedang berbunyi...',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}