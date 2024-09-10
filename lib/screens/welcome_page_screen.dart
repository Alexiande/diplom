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
  bool _obscurePassword = true; // Переменная для управления видимостью пароля

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0), // Горизонтальный отступ
        child: Align(
          alignment: Alignment.topCenter, // Выравнивание по верхнему центру
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // Центрирование по горизонтали
            children: [
              SizedBox(height: 150), // Отступ сверху
              Text(
                'Start Cooking',
                style: TextStyle(
                  fontSize: 22.0,
                  color: Color(0xFF2E3E5C),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 25), // Отступ между текстами
              Text(
                'Please enter your account here',
                style: TextStyle(
                  fontSize: 17.0,
                  color: Color(0xFF9FA5C0),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 25), // Дополнительный отступ перед текстовыми полями
              Container(
                width: double.infinity, // Ширина текстового поля на всю доступную ширину
                child: TextField(
                  keyboardType: TextInputType.text, // Устанавливаем тип клавиатуры
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9@.]')),
                  ],
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
                      borderSide: BorderSide(color: Color(0xFF9FA5C0)),
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF9FA5C0)),
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
              SizedBox(height: 25), // Отступ между текстовыми полями
              Container(
                width: double.infinity, // Ширина текстового поля на всю доступную ширину
                child: TextField(
                  obscureText: _obscurePassword, // Скрывать или показывать текст
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
                      borderSide: BorderSide(color: Color(0xFF9FA5C0)),
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF9FA5C0)),
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