import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../services/storage_service.dart';

class ConfigureHabitsScreen extends StatefulWidget {
  @override
  _ConfigureHabitsScreenState createState() => _ConfigureHabitsScreenState();
}

class _ConfigureHabitsScreenState extends State<ConfigureHabitsScreen> {
  final _habitController = TextEditingController();
  Color selectedColor = Colors.blue;
  
  final List<Color> availableColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.teal,
    Colors.indigo,
    Colors.amber,
    Colors.cyan,
  ];

  _addHabit() async {
    if (_habitController.text.isNotEmpty) {
      final habits = await StorageService.getHabits();
      final newHabit = Habit(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _habitController.text,
        color: selectedColor,
        createdAt: DateTime.now(),
      );
      
      habits.add(newHabit);
      await StorageService.saveHabits(habits);
      
      _habitController.clear();
      setState(() {
        selectedColor = availableColors[0];
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Habit added successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configure Habits'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add New Habit',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _habitController,
              decoration: InputDecoration(
                labelText: 'Habit Name',
                border: OutlineInputBorder(),
                hintText: 'Enter habit name...',
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Choose Color',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: availableColors.map((color) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedColor = color;
                    });
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: selectedColor == color
                          ? Border.all(color: Colors.black, width: 3)
                          : null,
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _addHabit,
              child: Text('Add Habit'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}