import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/WelcomeScreen.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  // Set the status bar style globally
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // Make the status bar transparent
    statusBarIconBrightness: Brightness.light, // Set icons to light
    statusBarBrightness: Brightness.light, // Set status bar background to light
  ));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Инициализация Firebase без параметров для мобильных устройств

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: const Color(0x00eff1f3)),
      home: const WelcomeScreen(),
    );
  }
}
