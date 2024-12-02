import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart'; // Імпортуємо пакет для перевірки з'єднання
import '../repository/user_repository.dart';
import 'home_screen.dart';
import 'registration_screen.dart';
import '../widgets/custom_text_field.dart';
import '../models/user.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final LocalUserRepository userRepository = LocalUserRepository();

  @override
  void initState() {
    super.initState();
    _checkAutoLogin(); // Перевірка автологування
  }

  void _checkAutoLogin() async {
    User? user = await userRepository.getUserInfo();
    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }

  void _loginUser() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Помилка з\'єднання'),
            content: Text('Відсутнє з\'єднання з інтернетом.'),
            actions: [
              TextButton(
                child: Text('Ок'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    final user = await userRepository.loginUser(
      _emailController.text,
      _passwordController.text,
    );

    if (user != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Успішний вхід'),
            content: Text('Ви успішно увійшли до системи.'),
            actions: [
              TextButton(
                child: Text('Ок'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Помилка'),
            content: Text('Неправильна електронна пошта або пароль'),
            actions: [
              TextButton(
                child: Text('Ок'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Вхід')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextField(
              controller: _emailController,
              labelText: 'Електронна пошта',
            ),
            SizedBox(height: 16),
            CustomTextField(
              controller: _passwordController,
              labelText: 'Пароль',
              isPassword: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loginUser,
              child: Text('Увійти'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistrationScreen()),
                );
              },
              child: Text('Реєстрація'),
            ),
          ],
        ),
      ),
    );
  }
}
