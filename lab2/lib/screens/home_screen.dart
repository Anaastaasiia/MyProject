import 'package:flutter/material.dart';
import 'package:lab2/widgets/custom_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isLargeScreen = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: SizedBox(
          width: isLargeScreen ? 600 : screenWidth * 0.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Welcome to the Home Page!'),
              CustomButton(
                text: 'Go to Profile',
                onPressed: () => Navigator.pushNamed(context, '/profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
