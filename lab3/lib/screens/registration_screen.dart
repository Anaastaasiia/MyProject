import 'package:flutter/material.dart';
import '../repository/user_repository.dart';
import '../models/user.dart';
import '../widgets/custom_text_field.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final LocalUserRepository userRepository = LocalUserRepository();

  void _registerUser() async {
  if (_nameController.text.isEmpty ||
      _surnameController.text.isEmpty ||
      _emailController.text.isEmpty ||
      !_emailController.text.contains('@') ||  // Додайте валідацію
      _passwordController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Заповніть всі поля')),
    );
    return;
  }

    final user = User(
      name: _nameController.text,
      surname: _surnameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );

    await userRepository.registerUser(user);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Реєстрація')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextField(
              controller: _nameController,
              labelText: 'Ім\'я',
            ),
            CustomTextField(
              controller: _surnameController,
              labelText: 'Прізвище',
            ),
            CustomTextField(
              controller: _emailController,
              labelText: 'Електронна пошта',
            ),
            CustomTextField(
              controller: _passwordController,
              labelText: 'Пароль',
              isPassword: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _registerUser,
              child: Text('Зареєструватися'),
            ),
          ],
        ),
      ),
    );
  }
}
