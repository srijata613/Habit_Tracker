import 'package:flutter/material.dart';

class HabitTemplate {
  final String name;
  final String category;
  final Color color;

  HabitTemplate({
    required this.name,
    required this.category,
    required this.color,
  });

  // Convert a HabitTemplate into a Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'color': color.value.toString(),
    };
  }

  // Create a HabitTemplate from a Map
  factory HabitTemplate.fromMap(Map<String, dynamic> map) {
    return HabitTemplate(
      name: map['name'],
      category: map['category'],
      color: Color(int.parse(map['color'])),
    );
  }
}
