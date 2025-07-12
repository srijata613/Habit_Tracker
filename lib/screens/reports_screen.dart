import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../services/storage_service.dart';


class ReportsScreen extends StatefulWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  List<Habit> habits = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  void _loadHabits() async {
    try {
      final loadedHabits = await StorageService.getHabits();
      setState(() {
        habits = loadedHabits;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Map<String, int> _getWeeklyProgress() {
    Map<String, int> progress = {};
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));

    for (var habit in habits) {
      int completedDays = 0;
      for (int i = 0; i < 7; i++) {
        final checkDate = startOfWeek.add(Duration(days: i));
        final dateKey = '${checkDate.year}-${checkDate.month.toString().padLeft(2, '0')}-${checkDate.day.toString().padLeft(2, '0')}';
        
        if (habit.completedDates.contains(dateKey)) {
          completedDays++;
        }
      }
      progress[habit.name] = completedDays;
    }
    return progress;
  }

  double _getOverallProgress() {
    if (habits.isEmpty) return 0.0;
    
    final weeklyProgress = _getWeeklyProgress();
    int totalCompleted = 0;
    int totalPossible = habits.length * 7;

    for (var count in weeklyProgress.values) {
      totalCompleted += count;
    }

    return totalPossible > 0 ? totalCompleted / totalPossible : 0.0;
  }

  Color _getProgressColor(int completedDays) {
    if (completedDays >= 6) return Colors.green;
    if (completedDays >= 4) return Colors.orange;
    if (completedDays >= 2) return Colors.yellow;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final weeklyProgress = _getWeeklyProgress();
    final overallProgress = _getOverallProgress();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly Reports'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: habits.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bar_chart,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No habits to track yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Add some habits to see your progress!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Overall Progress Card
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Overall Weekly Progress',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          LinearProgressIndicator(
                            value: overallProgress,
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              overallProgress >= 0.8 ? Colors.green :
                              overallProgress >= 0.6 ? Colors.orange :
                              overallProgress >= 0.4 ? Colors.yellow : Colors.red,
                            ),
                            minHeight: 8,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${(overallProgress * 100).toStringAsFixed(1)}% completed this week',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Individual Habit Progress
                  const Text(
                    'Individual Habit Progress',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: habits.length,
                    itemBuilder: (context, index) {
                      final habit = habits[index];
                      final completedDays = weeklyProgress[habit.name] ?? 0;
                      final progressPercentage = completedDays / 7;
                      
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: habit.color,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      habit.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '$completedDays/7 days',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: _getProgressColor(completedDays),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              LinearProgressIndicator(
                                value: progressPercentage,
                                backgroundColor: Colors.grey[300],
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  _getProgressColor(completedDays),
                                ),
                                minHeight: 6,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${(progressPercentage * 100).toStringAsFixed(0)}% completion rate',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Weekly Summary
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Weekly Summary',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total Habits:'),
                              Text(
                                habits.length.toString(),
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Best Performing:'),
                              Text(
                                weeklyProgress.isNotEmpty
                                    ? weeklyProgress.entries
                                        .reduce((a, b) => a.value > b.value ? a : b)
                                        .key
                                    : 'N/A',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Needs Improvement:'),
                              Text(
                                weeklyProgress.isNotEmpty
                                    ? weeklyProgress.entries
                                        .reduce((a, b) => a.value < b.value ? a : b)
                                        .key
                                    : 'N/A',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}