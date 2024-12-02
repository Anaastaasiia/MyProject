import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../services/local_storage_service.dart'; 
import '../app_colors.dart'; 
import 'registration_screen.dart'; 
import 'categories_screen.dart'; // Переконайся, що імпорт правильний

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final LocalStorageService _localStorageService = LocalStorageServiceImpl();

  @override
  void initState() {
    super.initState();
    _checkAutoLogin();
  }

  Future<void> _checkAutoLogin() async {
    final userData = await _localStorageService.getUserData();

    if (userData != null && await _isConnected()) {
      _showNotificationDialog('Auto-login succeeded.');
      // Перехід на CategoriesScreen, якщо є збережені дані користувача
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CategoriesScreen()), // Переконайся, що CategoriesScreen імпортований
      );
    } else if (userData != null) {
      _showNotificationDialog('Please connect to the network for auto-login.');
    }
  }

  Future<bool> _isConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  void _showNotificationDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Notification'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _login() async {
    if (!await _isConnected()) {
      _showNotificationDialog('No internet connection. Please try again.');
      return;
    }

    final email = _emailController.text;
    final password = _passwordController.text;
    final userData = await _localStorageService.getUserData();

    if (userData != null &&
        userData['email'] == email &&
        userData['password'] == password) {
      _showNotificationDialog('Login successful');
      // Перехід на CategoriesScreen після успішного логіну
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CategoriesScreen()), // Переконайся, що CategoriesScreen імпортований
      );
    } else {
      _showNotificationDialog('Invalid email or password');
    }
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('email');
              await prefs.remove('password');
              await prefs.remove('name');

              Navigator.of(context).pop(); 
            },
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login', style: TextStyle(color: AppColors.whiteColor)),
        backgroundColor: const Color(0xFF134B4B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistrationScreen()),
                );
              },
              child: Text('Register', style: TextStyle(color: const Color.fromARGB(255, 46, 77, 75))),
            ),
          ],
        ),
      ),
    );
  }
}
