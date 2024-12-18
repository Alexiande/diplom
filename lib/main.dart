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

  // Инициализация Firebase с разными опциями для Web
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCmMHVkDZzBJ3Ljq6dw4WKqDaFNb_3l3ls",
      authDomain: "easy-eat-6a9d2.firebaseapp.com",
      projectId: "easy-eat-6a9d2",
      storageBucket: "easy-eat-6a9d2.appspot.com",
      messagingSenderId: "76889669653",
      appId: "1:76889669653:web:your_app_id_here", // Замените на ваш appId
    ),
  );

  runApp(const MyApp());
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
