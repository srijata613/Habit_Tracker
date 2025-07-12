import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/habit.dart';
import '../services/storage_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _ageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List<String> prebuiltHabits = [
    'Drink Water',
    'Exercise',
    'Read Books',
    'Meditate',
    'Take Vitamins',
    'Walk 10k Steps',
    'Sleep 8 Hours',
    'Practice Gratitude',
  ];

  List<String> selectedHabits = [];

  _register() async {
    if (_formKey.currentState!.validate()) {
      final user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        username: _usernameController.text,
        password: _passwordController.text,
        age: int.parse(_ageController.text),
      );

      await StorageService.saveUser(user);

      // Create prebuilt habits
      List<Habit> habits = [];
      for (int i = 0; i < selectedHabits.length; i++) {
        final habitName = selectedHabits[i];
        habits.add(Habit(
          id: '${DateTime.now().millisecondsSinceEpoch}-$i',
          name: habitName,
          color: Colors.primaries[i % Colors.primaries.length],
          completedDates: [],
          streak: 0,
          createdAt: DateTime.now(),
        ));
      }

      await StorageService.saveHabits(habits);

      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter username';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _ageController,
                      decoration: InputDecoration(
                        labelText: 'Age',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your age';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 30),
                    Text(
                      'Select prebuilt habits:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    ...prebuiltHabits.map((habit) => CheckboxListTile(
                          title: Text(habit),
                          value: selectedHabits.contains(habit),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                selectedHabits.add(habit);
                              } else {
                                selectedHabits.remove(habit);
                              }
                            });
                          },
                        )),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: _register,
                child: Text('Sign Up'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
