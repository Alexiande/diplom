import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/WelcomeScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'; // Для kIsWeb

Future<void> main() async {
  // Set the status bar style globally
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // Make the status bar transparent
    statusBarIconBrightness: Brightness.light, // Set icons to light
    statusBarBrightness: Brightness.light, // Set status bar background to light
  ));

  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  if (kIsWeb) {
    // Для веб-приложения инициализируем Firebase с параметрами
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyAUd-rnHBHTXl33GpkPbNEKoo4ALXH6CNA",
        appId: "1:661221266888:web:b813d235f1e8e7b478f7e7",
        messagingSenderId: "661221266888",
        projectId: "maineasyeat",
        authDomain: "maineasyeat.firebaseapp.com",
        storageBucket: "maineasyeat.appspot.com",
      ),
    );
  } else {
    // Для мобильных платформ (Android/iOS) инициализация Firebase
    await Firebase.initializeApp(); // Initialize Firebase for mobile (Android/iOS)
  }

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
