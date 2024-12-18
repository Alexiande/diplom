import 'package:diplom/services/FirebaseAuth.dart';
import 'package:diplom/screens/HomePage.dart';
import 'package:diplom/screens/SignUpScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


void main() {
  runApp(const LoginScreen());
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const WelcomePage(),
    );
  }
}

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  bool _obscurePassword = true;
  bool _isEmailInvalid = false;
  bool _isPasswordInvalid = false;

  @override
  void initState() {
    super.initState();

    _emailController.addListener(() {
      setState(() {
        _isEmailInvalid = _containsRussianCharacters(_emailController.text) ||
            !_isEmailValid(_emailController.text);
      });
    });

    _passwordController.addListener(() {
      setState(() {
        _isPasswordInvalid =
            _containsRussianCharacters(_passwordController.text) ||
                !_isPasswordValid(_passwordController.text);
      });
    });
  }

  bool _containsRussianCharacters(String text) {
    final regex = RegExp(r'[а-яА-Я]');
    return regex.hasMatch(text);
  }

  bool _isEmailValid(String email) {
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return regex.hasMatch(email);
  }

  bool _isPasswordValid(String password) {
    return password.length >= 6; // Проверка на минимальную длину пароля
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(
            bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 150),
            const Text(
              'Welcome Back!',
              style: TextStyle(
                fontSize: 22.0,
                color: Color(0xFF2E3E5C),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              'Please enter your account here',
              style: TextStyle(
                fontSize: 17.0,
                color: Color(0xFF9FA5C0),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 25),
            // Email TextField
            SizedBox(
              width: double.infinity,
              child: TextField(
                controller: _emailController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email, color: Color(0xFF9FA5C0)),
                  labelText: 'Email or phone number',
                  labelStyle: const TextStyle(
                    color: Color(0xFF9FA5C0),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _isEmailInvalid ? Colors.red : const Color(
                          0xFF4169E1),
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _isEmailInvalid ? Colors.red : const Color(
                          0xFF9FA5C0),
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
              ),
            ),
            const SizedBox(height: 25),
            // Password TextField
            SizedBox(
              width: double.infinity,
              height: 56,
              child: TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock, color: Color(0xFF9FA5C0)),
                  labelText: 'Password',
                  labelStyle: const TextStyle(
                    color: Color(0xFF9FA5C0),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _isPasswordInvalid ? Colors.red : const Color(
                          0xFF4169E1),
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _isPasswordInvalid ? Colors.red : const Color(
                          0xFF9FA5C0),
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_outlined : Icons
                          .visibility_off_outlined,
                      color: const Color(0xFF9FA5C0),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: TextButton(
                  onPressed: () {
                    // Handle forgot password action here
                  },
                  child: const Text(
                    'Forgot password?',
                    style: TextStyle(
                      color: Color(0xFF2E3E5C),
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_isEmailInvalid || _isPasswordInvalid) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text(
                              'Please correct the errors above')),
                        );
                      } else {
                        _login(); // Вызываем метод входа
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5E6ED8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                      minimumSize: const Size(double.infinity, 56),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Or continue with',
                        style: TextStyle(
                          color: Color(0xFF9FA5C0),
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  ElevatedButton(
                    onPressed: () {
                      // Handle Google login action here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF5842),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                      minimumSize: const Size(double.infinity, 56),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.g_mobiledata_sharp,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Google',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Don’t have any account? ',
                  style: TextStyle(
                    color: Color(0xFF9FA5C0),
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          SignUpScreen()), // Переход на экран регистрации
                    );
                  },
                  child: const Text(
                    'Sign up',
                    style: TextStyle(
                      color: Color(0xFF5E6ED8),
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  void _login() async {
    User? user = await _authService.signInWithEmailAndPassword(
      _emailController.text,
      _passwordController.text,
    );
    if (user != null) {
      // Успешный вход, передаем userId на следующий экран
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(userId: user.uid)),
      );
    } else {
      // Ошибка
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login failed')),
      );
    }
  }
}