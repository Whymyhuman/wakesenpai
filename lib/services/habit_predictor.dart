
import 'package:tflite_flutter/tflite_flutter.dart';

class HabitPredictorService {
  late Interpreter _interpreter;

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/tflite/habit_model.tflite');
    } catch (e) {
      print('Gagal memuat model TensorFlow Lite: $e');
    }
  }

  // Stub metode prediksi
  Future<int> prediksiWaktuTundaSelanjutnya() async {
    // TODO: Implementasi logika prediksi menggunakan model TFLite
    // Untuk saat ini, kembalikan nilai dummy
    await Future.delayed(const Duration(seconds: 1)); // Simulasi proses prediksi
    return 5; // Contoh: memprediksi 5 menit tunda
  }

  void dispose() {
    _interpreter.close();
  }
}


