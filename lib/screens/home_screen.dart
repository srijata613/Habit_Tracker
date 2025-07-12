import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/habit.dart';
import '../services/storage_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Habit> habits = [];
  User? currentUser;
  late String today;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    today = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    _loadData();
  }

  _loadData() async {
    final user = await StorageService.getUser();
    final habitsList = await StorageService.getHabits();
    setState(() {
      currentUser = user;
      habits = habitsList;
    });
  }

  _toggleHabitCompletion(Habit habit) async {
    final index = habits.indexWhere((h) => h.id == habit.id);
    if (index == -1) return;

    setState(() {
      if (habit.completedDates.contains(today)) {
        habit.completedDates.remove(today);
      } else {
        habit.completedDates.add(today);
      }
    });

    await StorageService.saveHabits(habits);
  }

  @override
  Widget build(BuildContext context) {
    List<Habit> todoHabits = habits.where((h) => !h.completedDates.contains(today)).toList();
    List<Habit> doneHabits = habits.where((h) => h.completedDates.contains(today)).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Hello, ${currentUser?.name ?? 'User'}!'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ),
      ),
      body: habits.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_task, size: 80, color: Colors.grey),
                  SizedBox(height: 20),
                  Text(
                    'No habits yet!',
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                  Text(
                    'Tap the + button to add your first habit',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                if (todoHabits.isNotEmpty) ...[
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'To Do',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: todoHabits.length,
                      itemBuilder: (context, index) {
                        return _buildHabitItem(todoHabits[index], false);
                      },
                    ),
                  ),
                ],
                if (doneHabits.isNotEmpty) ...[
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Done',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: doneHabits.length,
                      itemBuilder: (context, index) {
                        return _buildHabitItem(doneHabits[index], true);
                      },
                    ),
                  ),
                ],
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/configure');
          _loadData();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildHabitItem(Habit habit, bool isCompleted) {
    return Dismissible(
      key: Key(habit.id),
      direction: isCompleted ? DismissDirection.endToStart : DismissDirection.startToEnd,
      onDismissed: (direction) {
        _toggleHabitCompletion(habit);
      },
      background: Container(
        color: isCompleted ? Colors.orange : Colors.green,
        alignment: isCompleted ? Alignment.centerRight : Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Icon(
          isCompleted ? Icons.undo : Icons.check,
          color: Colors.white,
        ),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: habit.color,
              shape: BoxShape.circle,
            ),
          ),
          title: Text(
            habit.name,
            style: TextStyle(
              decoration: isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Text(
            isCompleted ? 'Completed' : 'Swipe right to mark as done',
            style: TextStyle(
              color: isCompleted ? Colors.green : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
