import 'package:diplom/screens/LoginScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const WelcomeScreen());
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 25),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: 0.0, end: 2 * 3.14159).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(bottom: 20),
          child: Scaffold(
          body: Column(
          children: [
            // Сначала надпись "Easy Cook"
            const Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Easy Cook',
                      style: TextStyle(
                        fontSize: 32.0,
                        color: Color(0xFF9FA5C0),
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'Pacifico',
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            // Затем анимации с изображениями
            Expanded(
              flex: 3,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Главная картинка
                  RotationTransition(
                    turns: _animation,
                    child: SizedBox(
                      child: Image.asset('asset/image_1.png', fit: BoxFit.cover), // замените на свой актив
                    ),
                  ),
                  // Вращающиеся картинки
                  Positioned(
                    left: 15.0,
                    top: 10,
                    child: SizedBox(
                      child: Image.asset('asset/image_5.png', fit: BoxFit.cover), // замените на свой актив
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: SizedBox(
                      child: Image.asset('asset/image_5.png', fit: BoxFit.cover), // замените на свой актив
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: SizedBox(
                      child: Image.asset('asset/image_4.png', fit: BoxFit.cover), // замените на свой актив
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: SizedBox(
                      child: Image.asset('asset/image_3.png', fit: BoxFit.cover), // замените на свой актив
                    ),
                  ),
                ],
              ),
            ),
            // Внизу кнопка и дополнительный текст
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      'Start Cooking',
                      style: TextStyle(
                        fontSize: 22.0,
                        color: Color(0xFF2E3E5C),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'Let’s join our community\n    to cook better food!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17.0,
                        color: Color(0xFF9FA5C0),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 50.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const WelcomePage()),
                          );
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}
