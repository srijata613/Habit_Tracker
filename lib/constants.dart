import 'package:flutter/material.dart';
import '../models/habit.dart';

class AppConstants {
  // App Information
  static const String appName = 'Habit Tracker';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Build Better Habits Every Day';

  // Storage Keys
  static const String userKey = 'user_data';
  static const String habitsKey = 'habits_data';
  static const String completedHabitsKey = 'completed_habits';
  static const String settingsKey = 'app_settings';
  static const String notificationSettingsKey = 'notification_settings';

  // Default Colors for Habits
  static const List<Color> habitColors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.red,
    Colors.teal,
    Colors.indigo,
    Colors.pink,
    Colors.amber,
    Colors.cyan,
    Colors.lime,
    Colors.deepOrange,
  ];

  // Pre-built Habits for New Users
  static const List<Map<String, dynamic>> prebuiltHabits = [
    {
      'name': 'Drink Water',
      'description': 'Stay hydrated throughout the day',
      'color': 0xFF2196F3, // Blue
    },
    {
      'name': 'Morning Exercise',
      'description': 'Start your day with physical activity',
      'color': 0xFF4CAF50, // Green
    },
    {
      'name': 'Read for 30 minutes',
      'description': 'Expand your knowledge daily',
      'color': 0xFFFF9800, // Orange
    },
    {
      'name': 'Meditate',
      'description': 'Practice mindfulness and relaxation',
      'color': 0xFF9C27B0, // Purple
    },
    {
      'name': 'Eat Healthy',
      'description': 'Make nutritious food choices',
      'color': 0xFF8BC34A, // Light Green
    },
    {
      'name': 'Journal',
      'description': 'Write down your thoughts and experiences',
      'color': 0xFF3F51B5, // Indigo
    },
    {
      'name': 'Learn Something New',
      'description': 'Acquire new skills or knowledge',
      'color': 0xFFE91E63, // Pink
    },
    {
      'name': 'Take Vitamins',
      'description': 'Support your health with supplements',
      'color': 0xFFFF5722, // Deep Orange
    },
    {
      'name': 'Practice Gratitude',
      'description': 'Appreciate the good things in life',
      'color': 0xFF607D8B, // Blue Grey
    },
    {
      'name': 'Get 8 Hours Sleep',
      'description': 'Ensure adequate rest for recovery',
      'color': 0xFF795548, // Brown
    },
  ];

  // Time Slots for Notifications
  static const List<String> notificationTimes = [
    '6:00 AM',
    '7:00 AM',
    '8:00 AM',
    '9:00 AM',
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '1:00 PM',
    '2:00 PM',
    '3:00 PM',
    '4:00 PM',
    '5:00 PM',
    '6:00 PM',
    '7:00 PM',
    '8:00 PM',
    '9:00 PM',
    '10:00 PM',
  ];

  // Default Settings
  static const Map<String, dynamic> defaultSettings = {
    'theme': 'light',
    'notifications_enabled': true,
    'sound_enabled': true,
    'vibration_enabled': true,
    'daily_reminder_time': '8:00 AM',
    'show_progress': true,
    'show_streaks': true,
  };

  // Validation Rules
  static const int maxHabitNameLength = 50;
  static const int maxHabitDescriptionLength = 200;
  static const int maxUserNameLength = 30;
  static const int minPasswordLength = 6;
  static const int maxAge = 150;
  static const int minAge = 13;

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultMargin = 8.0;
  static const double defaultBorderRadius = 12.0;
  static const double defaultElevation = 4.0;

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 600);

  // Helper Methods
  static List<Habit> getPrebuiltHabits() {
    return prebuiltHabits.map((habitData) {
      return Habit(
        id: DateTime.now().millisecondsSinceEpoch.toString() + 
             habitData['name'].toString().replaceAll(' ', ''),
        name: habitData['name'],
        description: habitData['description'],
        color: habitData['color'],
        createdAt: DateTime.now(),
      );
    }).toList();
  }

  static TimeOfDay parseTimeString(String timeString) {
    final parts = timeString.split(':');
    final hour = int.parse(parts[0]);
    final minutePart = parts[1].split(' ');
    final minute = int.parse(minutePart[0]);
    final isAM = minutePart[1] == 'AM';
    
    int adjustedHour = hour;
    if (!isAM && hour != 12) {
      adjustedHour = hour + 12;
    } else if (isAM && hour == 12) {
      adjustedHour = 0;
    }
    
    return TimeOfDay(hour: adjustedHour, minute: minute);
  }

  static String formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod;
    final minute = time.minute;
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }

  static Color getColorByIndex(int index) {
    return habitColors[index % habitColors.length];
  }

  static String getStreakText(int streak) {
    if (streak == 0) return 'Start your streak!';
    if (streak == 1) return '1 day streak';
    if (streak < 7) return '$streak days streak';
    if (streak < 30) return '${(streak / 7).floor()} weeks streak';
    return '${(streak / 30).floor()} months streak';
  }

  static String getCompletionRateText(double rate) {
    if (rate >= 0.9) return 'Excellent!';
    if (rate >= 0.7) return 'Great job!';
    if (rate >= 0.5) return 'Good progress!';
    if (rate >= 0.3) return 'Keep going!';
    return 'You can do it!';
  }

  // Validation Methods
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }
    if (password.length < minPasswordLength) {
      return 'Password must be at least $minPasswordLength characters';
    }
    return null;
  }

  static String? validateName(String? name) {
    if (name == null || name.isEmpty) {
      return 'Name is required';
    }
    if (name.length > maxUserNameLength) {
      return 'Name must be less than $maxUserNameLength characters';
    }
    return null;
  }

  static String? validateAge(String? age) {
    if (age == null || age.isEmpty) {
      return 'Age is required';
    }
    final ageInt = int.tryParse(age);
    if (ageInt == null) {
      return 'Please enter a valid age';
    }
    if (ageInt < minAge || ageInt > maxAge) {
      return 'Age must be between $minAge and $maxAge';
    }
    return null;
  }

  static String? validateHabitName(String? name) {
    if (name == null || name.isEmpty) {
      return 'Habit name is required';
    }
    if (name.length > maxHabitNameLength) {
      return 'Habit name must be less than $maxHabitNameLength characters';
    }
    return null;
  }
}