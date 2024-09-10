import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const WelcomePageScreen ());
}

class WelcomePageScreen  extends StatelessWidget {
  const WelcomePageScreen ({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const WelcomePageScreen(),
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
  bool _obscurePassword = true;
  bool _isEmailInvalid = false;
  bool _isPasswordInvalid = false;

  @override
  void initState() {
    super.initState();

    _emailController.addListener(() {
      setState(() {
        _isEmailInvalid = _containsRussianCharacters(_emailController.text);
      });
    });

    _passwordController.addListener(() {
      setState(() {
        _isPasswordInvalid = _containsRussianCharacters(_passwordController.text);
      });
    });
  }

  bool _containsRussianCharacters(String text) {
    final regex = RegExp(r'[а-яА-Я]');
    return regex.hasMatch(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 150),
              Text(
                'Start Cooking',
                style: TextStyle(
                  fontSize: 22.0,
                  color: Color(0xFF2E3E5C),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 25),
              Text(
                'Please enter your account here',
                style: TextStyle(
                  fontSize: 17.0,
                  color: Color(0xFF9FA5C0),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 25),
              Container(
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
                        color: _isEmailInvalid ? Colors.red : Color(0xFF4169E1),
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: _isEmailInvalid ? Colors.red : Color(0xFF9FA5C0),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 25),
              Container(
                width: double.infinity,
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
                        color: _isPasswordInvalid ? Colors.red : Color(0xFF4169E1),
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: _isPasswordInvalid ? Colors.red : Color(0xFF9FA5C0),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                        color: Color(0xFF9FA5C0),
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
            ],
          ),
        ),
      ),
    );
  }
}