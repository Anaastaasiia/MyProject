import 'package:flutter/material.dart';
import '../repository/user_repository.dart';
import '../models/user.dart';
import '../widgets/custom_text_field.dart';

class ProfileScreen extends StatefulWidget {
  final Function(User) onUserUpdated;

  ProfileScreen({required this.onUserUpdated});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final LocalUserRepository userRepository = LocalUserRepository();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  void _loadUserInfo() async {
    User? user = await userRepository.getUserInfo();
    if (user != null) {
      setState(() {
        _nameController.text = user.name;
        _surnameController.text = user.surname;
        _emailController.text = user.email;
      });
    }
  }

  void _updateUserInfo() async {
    if (_nameController.text.isEmpty ||
        _surnameController.text.isEmpty ||
        _emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Заповніть всі поля')),
      );
      return;
    }

    if (!_emailController.text.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Неправильний формат електронної пошти')),
      );
      return;
    }

    // Запит на підтвердження
    bool confirm = await _showConfirmationDialog();
    if (!confirm) return;

    User updatedUser = User(
      name: _nameController.text,
      surname: _surnameController.text,
      email: _emailController.text,
      password: '', // Залишаємо пароль незмінним
    );

    await userRepository.registerUser(updatedUser);
    widget.onUserUpdated(updatedUser); // Оновлюємо користувача на головному екрані
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Інформацію оновлено')),
    );
  }

  Future<bool> _showConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Підтвердження'),
              content: Text('Ви впевнені, що хочете оновити інформацію?'),
              actions: [
                TextButton(
                  child: Text('Ні'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: Text('Так'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          },
        ) ??
        false; // Повертаємо false, якщо діалог не закритий
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Профіль користувача')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              controller: _nameController,
              labelText: 'Ім\'я',
            ),
            SizedBox(height: 16),
            CustomTextField(
              controller: _surnameController,
              labelText: 'Прізвище',
            ),
            SizedBox(height: 16),
            CustomTextField(
              controller: _emailController,
              labelText: 'Електронна пошта',
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateUserInfo,
              child: Text('Оновити інформацію'),
            ),
          ],
        ),
      ),
    );
  }
}
