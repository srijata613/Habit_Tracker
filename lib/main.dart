import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/configure_habits_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/personal_info_screen.dart';
import 'screens/reports_screen.dart';
import 'screens/notifications_screen.dart';
import 'models/user.dart';

void main() {
  runApp(HabitTrackerApp());
}

class HabitTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
        '/configure': (context) => ConfigureHabitsScreen(),
        '/settings': (context) => SettingsScreen(),
        '/personal-info': (context) => PersonalInfoScreen(
          user: User(
            id: 'demo-user',
            name: 'Guest',
            username: 'guest',
            password: '123456',
            age: 25,
          ),
          onUserUpdated: (user) {},
        ),
        '/reports': (context) => ReportsScreen(),
        '/notifications': (context) => NotificationsScreen(),
      },
    );
  }
}
