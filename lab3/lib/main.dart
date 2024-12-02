import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/profile_screen.dart'; // Переконайтеся, що цей імпорт є
import 'screens/registration_screen.dart';
import 'repository/user_repository.dart';
import 'models/user.dart'; // Додайте цей імпорт

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final LocalUserRepository userRepository = LocalUserRepository();
  User? user = await userRepository.getUserInfo();

  runApp(ScheduleApp(initialRoute: user != null ? '/home' : '/login'));
}

class ScheduleApp extends StatelessWidget {
  final String initialRoute;

  ScheduleApp({required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Schedule App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: initialRoute,
      routes: {
        '/home': (context) => HomeScreen(),
        '/login': (context) => LoginScreen(),
        '/profile': (context) => ProfileScreen(
          onUserUpdated: (User user) {
            // Реалізуйте, що має відбуватися після оновлення користувача
          },
        ),
        '/register': (context) => RegistrationScreen(),
      },
    );
  }
}
