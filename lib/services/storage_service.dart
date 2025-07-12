import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/habit.dart';
import '../models/user.dart';

class StorageService {
  static const String _usersKey = 'users';
  static const String _habitsKey = 'habits';
  static const String _currentUserKey = 'current_user';
  static const String _notificationSettingsKey = 'notification_settings';

  // User-related methods
  static Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final users = await getUsers();

    final existingIndex = users.indexWhere((u) => u.id == user.id);
    if (existingIndex != -1) {
      users[existingIndex] = user;
    } else {
      users.add(user);
    }

    final usersJson = users.map((u) => u.toJson()).toList();
    await prefs.setString(_usersKey, json.encode(usersJson));
  }

  static Future<List<User>> getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersString = prefs.getString(_usersKey);

    if (usersString == null) return [];

    final usersJson = json.decode(usersString) as List;
    return usersJson.map((u) => User.fromJson(u)).toList();
  }

  static Future<User?> getUserByUsername(String username) async {
    final users = await getUsers();
    try {
      return users.firstWhere((u) => u.username == username);
    } catch (e) {
      return null;
    }
  }

  static Future<User?> authenticateUser(String username, String password) async {
    final user = await getUserByUsername(username);
    if (user != null && user.password == password) {
      await setCurrentUser(user);
      return user;
    }
    return null;
  }

  static Future<void> setCurrentUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentUserKey, json.encode(user.toJson()));
  }

  static Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString(_currentUserKey);

    if (userString == null) return null;

    final userJson = json.decode(userString);
    return User.fromJson(userJson);
  }

  static Future<void> clearCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
  }

  // Public helper
  static Future<bool> isLoggedIn() async {
    final user = await getCurrentUser();
    return user != null;
  }

  static Future<User?> getUser() async {
    return await getCurrentUser();
  }

  static Future<void> logout() async {
    await clearCurrentUser();
  }

  // Habit-related methods
  static Future<void> saveHabit(Habit habit) async {
    final prefs = await SharedPreferences.getInstance();
    final habits = await getHabits();

    final existingIndex = habits.indexWhere((h) => h.id == habit.id);
    if (existingIndex != -1) {
      habits[existingIndex] = habit;
    } else {
      habits.add(habit);
    }

    final habitsJson = habits.map((h) => h.toJson()).toList();
    await prefs.setString(_habitsKey, json.encode(habitsJson));
  }

  static Future<void> saveHabits(List<Habit> habits) async {
    final prefs = await SharedPreferences.getInstance();
    final habitsJson = habits.map((h) => h.toJson()).toList();
    await prefs.setString(_habitsKey, json.encode(habitsJson));
  }

  static Future<List<Habit>> getHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final habitsString = prefs.getString(_habitsKey);

    if (habitsString == null) return [];

    final habitsJson = json.decode(habitsString) as List;
    return habitsJson.map((h) => Habit.fromJson(h)).toList();
  }

  static Future<void> deleteHabit(String habitId) async {
    final prefs = await SharedPreferences.getInstance();
    final habits = await getHabits();

    habits.removeWhere((h) => h.id == habitId);

    final habitsJson = habits.map((h) => h.toJson()).toList();
    await prefs.setString(_habitsKey, json.encode(habitsJson));
  }

  static Future<void> updateHabitProgress(String habitId, String date, bool isCompleted) async {
    final habits = await getHabits();
    final habitIndex = habits.indexWhere((h) => h.id == habitId);

    if (habitIndex != -1) {
      final habit = habits[habitIndex];

      if (isCompleted) {
        if (!habit.completedDates.contains(date)) {
          habit.completedDates.add(date);
        }
      } else {
        habit.completedDates.remove(date);
      }

      habit.streak = _calculateStreak(habit.completedDates);

      await saveHabit(habit);
    }
  }

  static Future<void> toggleHabitCompletion(String habitId) async {
    final today = DateTime.now();
    final todayString =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    final habits = await getHabits();
    final habitIndex = habits.indexWhere((h) => h.id == habitId);

    if (habitIndex != -1) {
      final habit = habits[habitIndex];
      final isCurrentlyCompleted = habit.completedDates.contains(todayString);

      await updateHabitProgress(habitId, todayString, !isCurrentlyCompleted);
    }
  }

  static Future<bool> isHabitCompletedToday(String habitId) async {
    final today = DateTime.now();
    final todayString =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    final habits = await getHabits();
    final habit = habits.firstWhere(
      (h) => h.id == habitId,
      orElse: () => Habit(
        id: '',
        name: '',
        color: const Color(0xFF2196F3),
        completedDates: [],
        streak: 0,
        createdAt: DateTime.now(),
      ),
    );

    return habit.completedDates.contains(todayString);
  }

  // Notification settings methods
  static Future<void> saveNotificationSettings(Map<String, dynamic> settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_notificationSettingsKey, json.encode(settings));
  }

  static Future<Map<String, dynamic>> getNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsString = prefs.getString(_notificationSettingsKey);

    if (settingsString == null) return {};

    return json.decode(settingsString) as Map<String, dynamic>;
  }

  // Helper to calculate streak
  static int _calculateStreak(List<String> completedDates) {
    final today = DateTime.now();
    int streak = 0;

    for (int i = 0; i < completedDates.length; i++) {
      final checkDate = today.subtract(Duration(days: i));
      final checkString =
          '${checkDate.year}-${checkDate.month.toString().padLeft(2, '0')}-${checkDate.day.toString().padLeft(2, '0')}';
      if (completedDates.contains(checkString)) {
        streak++;
      } else {
        break;
      }
    }

    return streak;
  }
}
