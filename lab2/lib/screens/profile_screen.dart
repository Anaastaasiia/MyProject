import 'package:flutter/material.dart';
import 'package:lab2/widgets/custom_button.dart';
import 'package:lab2/widgets/custom_text_field.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isLargeScreen = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SizedBox(
            width: isLargeScreen ? 600 : screenWidth * 0.9,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CustomTextField(label: 'First Name'),
                const CustomTextField(label: 'Last Name'),
                const CustomTextField(label: 'Email'),
                CustomButton(
                  text: 'Save Changes',
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
