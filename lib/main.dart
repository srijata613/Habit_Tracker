
import 'package:flutter/material.dart';
import 'package:habit_tracker/screens/login_screen.dart';
import 'package:habit_tracker/utils/constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: kAppName,
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: kPrimaryColor,
          secondary: kSecondaryColor,
          error: kErrorColor,
        ),
        textTheme: TextTheme(
          displayLarge: kHeadline1,     // replaces headline1
          displayMedium: kHeadline2,    // replaces headline2
          bodyLarge: kBodyText1,        // replaces bodyText1
          bodyMedium: kBodyText2,       // replaces bodyText2
        ),
      ),
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Optional HomeScreen
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(kHomeTitle),
      ),
      body: Center(
        child: Text('Welcome to the Habit Tracker App!'),
      ),
    );
  }
}
