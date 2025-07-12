import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/habit.dart';
import '../models/user.dart';

class HabitRepository {
  static final HabitRepository _instance = HabitRepository._internal();
  factory HabitRepository() => _instance;
  HabitRepository._internal();

  static const String _habitsKey = 'habits';
  static const String _userKey = 'user';
  static const String _completedHabitsKey = 'completed_habits';
  static const String _habitProgressKey = 'habit_progress';

  // User Management
  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  Future<void> deleteUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  // Habit Management
  Future<void> saveHabits(List<Habit> habits) async {
    final prefs = await SharedPreferences.getInstance();
    final habitsJson = habits.map((habit) => habit.toJson()).toList();
    await prefs.setString(_habitsKey, jsonEncode(habitsJson));
  }

  Future<List<Habit>> getHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final habitsJson = prefs.getString(_habitsKey);
    if (habitsJson != null) {
      final List<dynamic> habitsList = jsonDecode(habitsJson);
      return habitsList.map((json) => Habit.fromJson(json)).toList();
    }
    return [];
  }

  Future<void> addHabit(Habit habit) async {
    final habits = await getHabits();
    habits.add(habit);
    await saveHabits(habits);
  }

  Future<void> updateHabit(Habit updatedHabit) async {
    final habits = await getHabits();
    final index = habits.indexWhere((habit) => habit.id == updatedHabit.id);
    if (index != -1) {
      habits[index] = updatedHabit;
      await saveHabits(habits);
    }
  }

  Future<void> deleteHabit(String habitId) async {
    final habits = await getHabits();
    habits.removeWhere((habit) => habit.id == habitId);
    await saveHabits(habits);
  }

  // Completed Habits Management
  Future<void> saveCompletedHabits(Map<String, List<String>> completedHabits) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_completedHabitsKey, jsonEncode(completedHabits));
  }

  Future<Map<String, List<String>>> getCompletedHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final completedJson = prefs.getString(_completedHabitsKey);
    if (completedJson != null) {
      final Map<String, dynamic> decoded = jsonDecode(completedJson);
      return decoded.map((key, value) => MapEntry(key, List<String>.from(value)));
    }
    return {};
  }

  Future<void> markHabitComplete(String habitId, DateTime date) async {
    final completedHabits = await getCompletedHabits();
    final dateKey = _getDateKey(date);
    
    if (completedHabits[dateKey] == null) {
      completedHabits[dateKey] = [];
    }
    
    if (!completedHabits[dateKey]!.contains(habitId)) {
      completedHabits[dateKey]!.add(habitId);
      await saveCompletedHabits(completedHabits);
    }
  }

  Future<void> markHabitIncomplete(String habitId, DateTime date) async {
    final completedHabits = await getCompletedHabits();
    final dateKey = _getDateKey(date);
    
    if (completedHabits[dateKey] != null) {
      completedHabits[dateKey]!.remove(habitId);
      if (completedHabits[dateKey]!.isEmpty) {
        completedHabits.remove(dateKey);
      }
      await saveCompletedHabits(completedHabits);
    }
  }

  Future<bool> isHabitCompletedForDate(String habitId, DateTime date) async {
    final completedHabits = await getCompletedHabits();
    final dateKey = _getDateKey(date);
    return completedHabits[dateKey]?.contains(habitId) ?? false;
  }

  Future<List<String>> getCompletedHabitsForDate(DateTime date) async {
    final completedHabits = await getCompletedHabits();
    final dateKey = _getDateKey(date);
    return completedHabits[dateKey] ?? [];
  }

  // Habit Progress Analytics
  Future<Map<String, int>> getWeeklyProgress(DateTime startDate) async {
    final Map<String, int> progress = {};
    final habits = await getHabits();
    
    for (int i = 0; i < 7; i++) {
      final date = startDate.add(Duration(days: i));
      final completedHabits = await getCompletedHabitsForDate(date);
      final dateKey = _getDateKey(date);
      progress[dateKey] = completedHabits.length;
    }
    
    return progress;
  }

  Future<Map<String, double>> getHabitCompletionRates(DateTime startDate, DateTime endDate) async {
    final habits = await getHabits();
    final Map<String, double> completionRates = {};
    
    for (final habit in habits) {
      int totalDays = endDate.difference(startDate).inDays + 1;
      int completedDays = 0;
      
      for (int i = 0; i < totalDays; i++) {
        final date = startDate.add(Duration(days: i));
        if (await isHabitCompletedForDate(habit.id, date)) {
          completedDays++;
        }
      }
      
      completionRates[habit.name] = totalDays > 0 ? completedDays / totalDays : 0.0;
    }
    
    return completionRates;
  }

  // Clear all data
  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Utility methods
  String _getDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  DateTime _parseDateKey(String dateKey) {
    final parts = dateKey.split('-');
    return DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  }
}