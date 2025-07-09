import 'package:flutter/material.dart';
import 'template_selection_screen.dart'; // Assumes HabitTemplate is also defined here

class ConfigureHabitsScreen extends StatefulWidget {
  @override
  _ConfigureHabitsScreenState createState() => _ConfigureHabitsScreenState();
}

class _ConfigureHabitsScreenState extends State<ConfigureHabitsScreen> {
  List<Color> colors = [Colors.red, Colors.green, Colors.blue, Colors.orange];
  Color selectedColor = Colors.blue;
  List<String> categories = ['Health', 'Work', 'Personal Development', 'Other'];
  String selectedCategory = 'Health';

  // Updated to hold HabitTemplate objects
  List<HabitTemplate> userHabits = [];

  // Example habit templates using HabitTemplate
  List<HabitTemplate> habitTemplates = [
    HabitTemplate(name: 'Morning Jog', category: 'Health', color: Colors.red),
    HabitTemplate(name: 'Meditation', category: 'Personal Development', color: Colors.green),
    HabitTemplate(name: 'Read 10 Pages', category: 'Personal Development', color: Colors.blue),
    HabitTemplate(name: 'Check Emails', category: 'Work', color: Colors.orange),
  ];

  void _selectTemplate() async {
    final selectedTemplate = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TemplateSelectionScreen(templates: habitTemplates),
      ),
    );

    if (selectedTemplate != null && selectedTemplate is HabitTemplate) {
      setState(() {
        userHabits.add(selectedTemplate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configure Habits'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          // Dropdown to select category
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: selectedCategory,
              onChanged: (String? newValue) {
                setState(() {
                  selectedCategory = newValue!;
                });
              },
              items: categories.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),

          // Template selection button
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: ElevatedButton(
              onPressed: _selectTemplate,
              child: Text('Select from Templates'),
            ),
          ),

          // Display selected habits
          Expanded(
            child: ListView.builder(
              itemCount: userHabits.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(backgroundColor: userHabits[index].color),
                  title: Text(userHabits[index].name),
                  subtitle: Text('Category: ${userHabits[index].category}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
