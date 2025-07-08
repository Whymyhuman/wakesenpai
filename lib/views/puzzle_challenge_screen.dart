import 'package:flutter/material.dart';

class PuzzleChallengeScreen extends StatefulWidget {
  final VoidCallback onChallengeCompleted;

  const PuzzleChallengeScreen({super.key, required this.onChallengeCompleted});

  @override
  State<PuzzleChallengeScreen> createState() => _PuzzleChallengeScreenState();
}

class _PuzzleChallengeScreenState extends State<PuzzleChallengeScreen> {
  List<int> puzzlePieces = [1, 2, 3, 4, 5, 6, 7, 8, 0];
  List<int> correctOrder = [1, 2, 3, 4, 5, 6, 7, 8, 0];
  
  @override
  void initState() {
    super.initState();
    _shufflePuzzle();
  }
  
  void _shufflePuzzle() {
    puzzlePieces.shuffle();
    setState(() {});
  }
  
  void _movePiece(int index) {
    int emptyIndex = puzzlePieces.indexOf(0);
    
    if (_isAdjacent(index, emptyIndex)) {
      setState(() {
        int temp = puzzlePieces[index];
        puzzlePieces[index] = puzzlePieces[emptyIndex];
        puzzlePieces[emptyIndex] = temp;
      });
      
      if (_isPuzzleSolved()) {
        widget.onChallengeCompleted();
      }
    }
  }
  
  bool _isAdjacent(int index1, int index2) {
    int row1 = index1 ~/ 3;
    int col1 = index1 % 3;
    int row2 = index2 ~/ 3;
    int col2 = index2 % 3;
    
    return (row1 == row2 && (col1 - col2).abs() == 1) ||
           (col1 == col2 && (row1 - row2).abs() == 1);
  }
  
  bool _isPuzzleSolved() {
    for (int i = 0; i < puzzlePieces.length; i++) {
      if (puzzlePieces[i] != correctOrder[i]) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tantangan Puzzle'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Susun angka 1-8 dengan benar!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemCount: 9,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _movePiece(index),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        color: puzzlePieces[index] == 0 
                            ? Colors.grey[300] 
                            : Colors.blue[100],
                      ),
                      child: Center(
                        child: puzzlePieces[index] == 0
                            ? null
                            : Text(
                                '${puzzlePieces[index]}',
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                widget.onChallengeCompleted();
              },
              child: const Text('Skip (Testing)'),
            ),
          ],
        ),
      ),
    );
  }
}