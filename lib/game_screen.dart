import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final List<Color> allColors = [Colors.red, Colors.green, Colors.blue, Colors.orange];
  late Color targetColor;
  List<Color> boxColors = [];
  int score = 0;
  int remainingTime = 30;
  String message = '';
  Timer? countdownTimer;
  int tappedIndex = -1;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    score = 0;
    remainingTime = 30;
    tappedIndex = -1;
    generateNewColors();

    countdownTimer?.cancel();
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingTime > 0) {
          remainingTime--;
        } else {
          timer.cancel();
          message = "⏰ Time's up! Final Score: $score";
        }
      });
    });
  }

  void generateNewColors() {
    final random = Random();

    // 1. Hedef rengi seç
    targetColor = allColors[random.nextInt(allColors.length)];

    // 2. 3 farklı rastgele renk + hedef rengi → karıştır
    boxColors = List<Color>.from(allColors)..remove(targetColor);
    boxColors = boxColors..shuffle();
    boxColors = boxColors.take(3).toList(); // 3 farklı renk
    boxColors.add(targetColor); // hedef rengi ekle
    boxColors.shuffle(); // sıralamayı karıştır

    setState(() {
      message = "🎯 Tap the ${colorName(targetColor)} box!";
      tappedIndex = -1;
    });
  }

  void checkTap(int index) {
    final tappedColor = boxColors[index];
    setState(() {
      tappedIndex = index;
    });

    Future.delayed(const Duration(milliseconds: 150), () {
      if (tappedColor == targetColor && remainingTime > 0) {
        setState(() {
          score++;
        });
        generateNewColors();
      } else {
        countdownTimer?.cancel();
        setState(() {
          message = "❌ Wrong box! Final Score: $score";
        });
      }
    });
  }

  String colorName(Color color) {
    if (color == Colors.red) return "red";
    if (color == Colors.green) return "green";
    if (color == Colors.blue) return "blue";
    if (color == Colors.orange) return "orange";
    return "unknown";
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Color Tap Game'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "⏳ Time: $remainingTime s",
              style: const TextStyle(fontSize: 18, color: Colors.black54),
            ),
            const SizedBox(height: 5),
            Text(
              "🏆 Score: $score",
              style: const TextStyle(fontSize: 18, color: Colors.black87),
            ),
            const SizedBox(height: 30),
            Center(
              child: SizedBox(
                width: 220,
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: boxColors.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    final color = boxColors[index];
                    final isTapped = index == tappedIndex;

                    return GestureDetector(
                      onTap: () => checkTap(index),
                      child: AnimatedScale(
                        duration: const Duration(milliseconds: 150),
                        scale: isTapped ? 1.2 : 1.0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.black12),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: startGame,
              child: const Text("🔁 Restart Game"),
            ),
          ],
        ),
      ),
    );
  }
}
