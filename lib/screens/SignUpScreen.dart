import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'SearchPageScreen.dart'; // Импортируйте вашу страницу поиска

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _obscurePassword = true;
  bool _isPasswordValid = false;
  bool _containsNumber = false;

  void _checkPassword(String password) {
    setState(() {
      _isPasswordValid = password.length >= 6;
      _containsNumber = RegExp(r'\d').hasMatch(password);
    });
  }

  Future<void> _register() async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Успешная регистрация
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SearchPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            const Text(
              'Welcome!',
              style: TextStyle(
                fontSize: 22.0,
                color: Color(0xFF2E3E5C),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Please enter your account here',
              style: TextStyle(
                fontSize: 17.0,
                color: Color(0xFF9FA5C0),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email, color: Color(0xFF9FA5C0)),
                  labelText: 'Email',
                  labelStyle: const TextStyle(color: Color(0xFF9FA5C0)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                onChanged: _checkPassword,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock, color: Color(0xFF9FA5C0)),
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Color(0xFF9FA5C0)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      _isPasswordValid ? Icons.check_circle : Icons.cancel,
                      color: _isPasswordValid ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    const Text('At least 6 characters'),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      _containsNumber ? Icons.check_circle : Icons.cancel,
                      color: _containsNumber ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    const Text('Contains a number'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: _isPasswordValid && _containsNumber ? _register : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5E6ED8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
                minimumSize: const Size(double.infinity, 56),
              ),
              child: const Text(
                'Sign Up',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}