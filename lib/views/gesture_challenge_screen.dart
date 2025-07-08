
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
  final double _shakeThreshold = 10.0; // Ambang batas goyangan
  final int _requiredShakes = 5; // Jumlah goyangan yang dibutuhkan
  StreamSubscription? _accelerometerSubscription;

  @override
  void initState() {
    super.initState();
    _accelerometerSubscription = accelerometerEventStream(samplingPeriod: SensorInterval.normalInterval).listen(
      (AccelerometerEvent event) {
        final double acceleration = math.sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
        if (acceleration > _shakeThreshold) {
          setState(() {
            _shakeCount++;
          });
          if (_shakeCount >= _requiredShakes) {
            _accelerometerSubscription?.cancel();
            widget.onChallengeCompleted();
            Navigator.pop(context);
          }
        }
      },
      onError: (error) {
        print('Accelerometer error: $error');
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tantangan Goyang"),
        automaticallyImplyLeading: false, // Sembunyikan tombol kembali
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Goyangkan ponsel Anda untuk menghentikan alarm!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              "Goyangan: ${_shakeCount.toInt()}/$_requiredShakes",
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 50),
            const Icon(
              Icons.screen_rotation,
              size: 100,
              color: Colors.blueAccent,
            ),
          ],
        ),
      ),
    );
  }
}


