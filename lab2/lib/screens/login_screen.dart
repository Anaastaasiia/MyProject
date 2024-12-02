import 'package:flutter/material.dart';
import 'package:lab2/widgets/custom_button.dart';
import 'package:lab2/widgets/custom_text_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isLargeScreen = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SizedBox(
            width: isLargeScreen ? 600 : screenWidth * 0.9,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CustomTextField(label: 'Email'),
                const CustomTextField(label: 'Password', obscureText: true),
                CustomButton(
                  text: 'Login',
                  onPressed: () => Navigator.pushNamed(context, '/home'),
                ),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/register'),
                  child: const Text("Don't have an account? Register"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
