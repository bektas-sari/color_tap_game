import 'package:flutter/material.dart';
import 'game_screen.dart';

void main() {
  runApp(const ColorTapGame());
}

class ColorTapGame extends StatelessWidget {
  const ColorTapGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Color Tap Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Color Tap Game'),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const GameScreen()),
            );
          },

          child: const Text('Start Game'),
        ),
      ),
    );
  }
}
