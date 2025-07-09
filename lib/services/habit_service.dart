import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Habit {
  final String name;
  final String category;
  final String color;
  bool isCompleted;

  Habit({
    required this.name,
    required this.category,
    required this.color,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'color': color,
      'isCompleted': isCompleted,
    };
  }

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      name: map['name'],
      category: map['category'],
      color: map['color'],
      isCompleted: map['isCompleted'],
    );
  }
}

class HabitService {
  static const String _habitsKey = 'habits';

  Future<List<Habit>> getHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final habitsJson = prefs.getStringList(_habitsKey) ?? [];
    return habitsJson.map((habit) => Habit.fromMap(json.decode(habit))).toList();
  }

  Future<void> addHabit(Habit habit) async {
    final prefs = await SharedPreferences.getInstance();
    final habits = await getHabits();
    habits.add(habit);
    final habitsJson = habits.map((habit) => json.encode(habit.toMap())).toList();
    await prefs.setStringList(_habitsKey, habitsJson);
  }

  Future<void> updateHabit(int index, Habit habit) async {
    final prefs = await SharedPreferences.getInstance();
    final habits = await getHabits();
    habits[index] = habit;
    final habitsJson = habits.map((habit) => json.encode(habit.toMap())).toList();
    await prefs.setStringList(_habitsKey, habitsJson);
  }

  Future<void> deleteHabit(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final habits = await getHabits();
    habits.removeAt(index);
    final habitsJson = habits.map((habit) => json.encode(habit.toMap())).toList();
    await prefs.setStringList(_habitsKey, habitsJson);
  }
}
