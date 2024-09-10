import 'package:diplom/screens/welcome_page_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const WelcomeScreen ());
}

class WelcomeScreen  extends StatelessWidget {
  const WelcomeScreen ({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Easy Eat',
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFFFFFFF)),
      home: const MyHomePage(title: 'Flutter Home Page'),
         );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              'Easy Cook',
              style: TextStyle(
                fontSize: 32.0,
                color: Color(0xFF9FA5C0),
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                fontFamily: 'Pacifico',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Image.asset('asset/image_1.png'), // replace with your image asset
            ),
          ),
          const Center(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    'Start Cooking',
                    style: TextStyle(
                      fontSize: 22.0,
                      color: Color(0xFF2E3E5C),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    'Let’s join our community\n    to cook better food!',
                    style: TextStyle(
                      fontSize: 17.0,
                      color: Color(0xFF9FA5C0),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 50.0),
          Container(
            margin: const EdgeInsets.only(bottom: 40.0, left: 15.0, right: 15.0),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                MaterialPageRoute(builder:
                (context)=>WelcomePage()));
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(25.0),
                backgroundColor: const Color(0xFF5E6ED8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
              ),
              child: const Text(
                'Get Started',
                style: TextStyle(
                  color: Color(0xFFEFF1F3),
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
