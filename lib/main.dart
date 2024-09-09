import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart'; // Импортируем экран приветствия

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Easy Eat',
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xEFF1F3)),
      home: const WelcomeScreen(),
    );
  }
}
