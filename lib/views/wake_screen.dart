import 'package:flutter/material.dart';
import '../models/alarm.dart';
import 'puzzle_challenge_screen.dart';
import 'gesture_challenge_screen.dart';

class WakeScreen extends StatefulWidget {
  final Alarm alarm;

  const WakeScreen({super.key, required this.alarm});

  @override
  State<WakeScreen> createState() => _WakeScreenState();
}

class _WakeScreenState extends State<WakeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade800, Colors.blue.shade400],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: const Icon(
                    Icons.alarm,
                    size: 100,
                    color: Colors.white,
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
                  widget.alarm.timeString,
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
                          Text('BANGUN', style: TextStyle(fontSize: 16)),
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
                          Text('TUNDA', style: TextStyle(fontSize: 16)),
                        ],
                      ),
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

  void _stopAlarm() {
    switch (widget.alarm.challengeType) {
      case 'puzzle':
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
        break;
      case 'gesture':
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
        break;
      default:
        Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  void _snoozeAlarm() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Alarm ditunda 5 menit')),
    );
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}