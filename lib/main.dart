import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/welcome_screen.dart';


void main() {
  // Set the status bar style globally
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // Make the status bar transparent
    statusBarIconBrightness: Brightness.light, // Set icons to light
    statusBarBrightness: Brightness.light, // Set status bar background to light
  ));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Easy Eat',
      theme: ThemeData(scaffoldBackgroundColor: const Color(0x00eff1f3)),
      home: const WelcomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
