import 'package:flutter/material.dart';

void main() {
  runApp(const WelcomePageScreen ());
}

class WelcomePageScreen  extends StatelessWidget {
  const WelcomePageScreen ({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Easy Eat',
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFFFFFFF)),
      home: const WelcomePageScreen(),
    );
  }
}
class WelcomePage extends StatelessWidget {

  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Next Page'),),
      body: Center(
        child: Text('GeeksForGeeks'),
      ),
    );
  }
}
