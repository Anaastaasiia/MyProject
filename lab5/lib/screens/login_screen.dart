import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import '../services/local_storage_service.dart'; 
import '../app_colors.dart'; 
import 'registration_screen.dart'; 
import 'categories_screen.dart'; 

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final LocalStorageService _localStorageService = LocalStorageServiceImpl();
  List<Map<String, dynamic>> _users = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
    _checkAutoLogin();
  }

  Future<void> _fetchUsers() async {
    const apiUrl = 'https://run.mocky.io/v3/4a490dac-ab51-4582-9b1b-7efd39f53380';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _users = List<Map<String, dynamic>>.from(data['users']);
        });
      } else {
        _showNotificationDialog('Failed to load user data.');
      }
    } catch (e) {
      _showNotificationDialog('Error fetching user data: $e');
    }
  }

  Future<void> _checkAutoLogin() async {
    final userData = await _localStorageService.getUserData();
    if (userData != null && await _isConnected()) {
      _showNotificationDialog('Auto-login succeeded.');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CategoriesScreen()),
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

    // Перевірка введених даних з даними з API
    final user = _users.firstWhere(
      (user) => user['email'] == email && user['password'] == password,
    );

    if (user != null) {
      _showNotificationDialog('Login successful');
      await _localStorageService.saveUserData(email, password, user['name']);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CategoriesScreen()),
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
