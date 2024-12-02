import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';


abstract class UserRepository {
  Future<void> registerUser(User user);
  Future<User?> loginUser(String email, String password);
  Future<User?> getUserInfo();
}


class LocalUserRepository implements UserRepository {
  @override
  Future<void> registerUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', user.name);
    await prefs.setString('surname', user.surname);
    await prefs.setString('email', user.email);
    await prefs.setString('password', user.password);
  }


  @override
  Future<User?> loginUser(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('email');
    final savedPassword = prefs.getString('password');


    if (savedEmail == email && savedPassword == password) {
      return User(
        name: prefs.getString('name') ?? '',
        surname: prefs.getString('surname') ?? '',
        email: email,
        password: password,
      );
    }
    return null;
  }


  @override
  Future<User?> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('name');
    final surname = prefs.getString('surname');
    final email = prefs.getString('email');
    final password = prefs.getString('password');


    if (name != null && surname != null && email != null && password != null) {
      return User(
        name: name,
        surname: surname,
        email: email,
        password: password,
      );
    }
    return null;
  }
}
