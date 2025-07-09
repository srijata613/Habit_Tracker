
import 'package:flutter/material.dart';

// 1. DEFINE THE HABITTEMPLATE CLASS
// This class holds the data structure for your habit templates.
class HabitTemplate {
  final String name;
  final String category;
  final Color color;

  // Constructor for the class
  HabitTemplate({
    required this.name,
    required this.category,
    required this.color,
  });
}


// 2. YOUR WIDGET (No changes needed here)
class TemplateSelectionScreen extends StatelessWidget {
  final List<HabitTemplate> templates;

  const TemplateSelectionScreen({super.key, required this.templates}); // Added super.key for best practice

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Habit Templates')),
      body: ListView.builder(
        itemCount: templates.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(backgroundColor: templates[index].color),
            title: Text(templates[index].name),
            subtitle: Text(templates[index].category),
            onTap: () {
              Navigator.pop(context, templates[index]);
            },
          );
        },
      ),
    );
  }
}