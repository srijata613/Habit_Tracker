import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static Future<bool> login(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final storedPassword = prefs.getString('user_$username');
    return storedPassword != null && storedPassword == password;
  }

  static Future<void> register(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_$username', password);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('loggedInUser');
  }

  static Future<void> setLoggedInUser(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('loggedInUser', username);
  }

  static Future<String?> getLoggedInUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('loggedInUser');
  }
}
