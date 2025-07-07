import 'package:flutter/material.dart';
import 'package:flutter_drag_and_drop/flutter_drag_and_drop.dart';

class PuzzleChallengeScreen extends StatefulWidget {
  final VoidCallback onChallengeCompleted;

  const PuzzleChallengeScreen({super.key, required this.onChallengeCompleted});

  @override
  State<PuzzleChallengeScreen> createState() => _PuzzleChallengeScreenState();
}

class _PuzzleChallengeScreenState extends State<PuzzleChallengeScreen> {
  // TODO: Implementasi logika puzzle game
  // Misalnya, membagi gambar menjadi potongan-potongan dan mengacaknya
  // Kemudian, biarkan pengguna menyeret dan menjatuhkan potongan ke posisi yang benar

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tantangan Puzzle'),
        automaticallyImplyLeading: false, // Sembunyikan tombol kembali
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Susun potongan gambar ini!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Placeholder untuk area puzzle
            Container(
              width: 300,
              height: 300,
              color: Colors.grey[300],
              child: const Center(
                child: Text('Area Puzzle (Implementasi Drag and Drop)'),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Simulasi tantangan selesai
                widget.onChallengeCompleted();
                Navigator.pop(context);
              },
              child: const Text('Selesai (Simulasi)'),
            ),
          ],
        ),
      ),
    );
  }
}


