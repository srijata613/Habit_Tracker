import 'package:flutter/material.dart';

class Habit {
  final String id;
  final String name;
  final Color color;
  final DateTime createdAt;
  List<String> completedDates; // ISO date strings
  int streak;
  bool notificationEnabled;
  TimeOfDay? notificationTime;

  Habit({
    required this.id,
    required this.name,
    required this.color,
    required this.createdAt,
    this.completedDates = const [],
    this.streak = 0,
    this.notificationEnabled = false,
    this.notificationTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color.value,
      'createdAt': createdAt.toIso8601String(),
      'completedDates': completedDates,
      'streak': streak,
      'notificationEnabled': notificationEnabled,
      'notificationTime': notificationTime != null
          ? {'hour': notificationTime!.hour, 'minute': notificationTime!.minute}
          : null,
    };
  }

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'],
      name: json['name'],
      color: Color(json['color']),
      createdAt: DateTime.parse(json['createdAt']),
      completedDates: List<String>.from(json['completedDates'] ?? []),
      streak: json['streak'] ?? 0,
      notificationEnabled: json['notificationEnabled'] ?? false,
      notificationTime: json['notificationTime'] != null
          ? TimeOfDay(
              hour: json['notificationTime']['hour'],
              minute: json['notificationTime']['minute'],
            )
          : null,
    );
  }
}
