import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';
import 'dart:math' as math;

class GestureChallengeScreen extends StatefulWidget {
  final VoidCallback onChallengeCompleted;

  const GestureChallengeScreen({super.key, required this.onChallengeCompleted});

  @override
  State<GestureChallengeScreen> createState() => _GestureChallengeScreenState();
}

class _GestureChallengeScreenState extends State<GestureChallengeScreen> {
  double _shakeCount = 0;
  final double _shakeThreshold = 12.0;
  final int _requiredShakes = 5;
  StreamSubscription? _accelerometerSubscription;
  DateTime? _lastShakeTime;

  @override
  void initState() {
    super.initState();
    _startListening();
  }

  void _startListening() {
    _accelerometerSubscription = accelerometerEventStream().listen(
      (AccelerometerEvent event) {
        final now = DateTime.now();
        
        // Prevent too frequent shake detection
        if (_lastShakeTime != null && 
            now.difference(_lastShakeTime!).inMilliseconds < 500) {
          return;
        }

        // Calculate total acceleration magnitude
        final double totalAcceleration = math.sqrt(
          event.x * event.x + event.y * event.y + event.z * event.z,
        );
        
        // Remove gravity (approximately 9.8 m/s²) and get absolute value
        final double netAcceleration = (totalAcceleration - 9.8).abs();
        
        if (netAcceleration > _shakeThreshold) {
          _lastShakeTime = now;
          setState(() {
            _shakeCount++;
          });
          
          if (_shakeCount >= _requiredShakes) {
            _accelerometerSubscription?.cancel();
            widget.onChallengeCompleted();
          }
        }
      },
      onError: (error) {
        debugPrint('Accelerometer error: $error');
      },
    );
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = _shakeCount / _requiredShakes;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tantangan Goyang'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Goyangkan ponsel Anda!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              'Goyangan: ${_shakeCount.toInt()}/$_requiredShakes',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 30),
            
            // Progress indicator
            Container(
              width: 200,
              height: 20,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(10),
              ),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.transparent,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
            
            const SizedBox(height: 50),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              transform: Matrix4.rotationZ(progress * 0.1),
              child: const Icon(
                Icons.screen_rotation,
                size: 100,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 50),
            
            if (kDebugMode)
              ElevatedButton(
                onPressed: () {
                  widget.onChallengeCompleted();
                },
                child: const Text('Skip (Debug Mode)'),
              ),
          ],
        ),
      ),
    );
  }
}