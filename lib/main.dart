import 'package:flutter/material.dart';
import 'screens/game_screen.dart';

void main() {
  runApp(const TetrisApp());
}

class TetrisApp extends StatelessWidget {
  const TetrisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '俄罗斯方块',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'monospace'),
      home: const GameScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
