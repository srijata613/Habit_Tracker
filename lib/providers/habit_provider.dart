import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../models/user.dart';
import '../services/habit_repository.dart';
import '../services/notification_service.dart';


class HabitProvider extends ChangeNotifier {
  final HabitRepository _repository = HabitRepository();
  final NotificationService _notificationService = NotificationService();

  List<Habit> _habits = [];
  User? _currentUser;
  Map<String, List<String>> _completedHabits = {};
  bool _isLoading = false;

  List<Habit> get habits => _habits;
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  List<Habit> get pendingHabits {
    final today = DateTime.now();
    final completedToday = _completedHabits[_getDateKey(today)] ?? [];
    return _habits.where((habit) => !completedToday.contains(habit.id)).toList();
  }

  List<Habit> get completedHabits {
    final today = DateTime.now();
    final completedToday = _completedHabits[_getDateKey(today)] ?? [];
    return _habits.where((habit) => completedToday.contains(habit.id)).toList();
  }

  Future<void> initialize() async {
    await _loadUser();
    await _loadHabits();
    await _loadCompletedHabits();
    await _notificationService.initialize();
  }

  Future<void> _loadUser() async {
    _currentUser = await _repository.getUser();
    notifyListeners();
  }

  Future<void> _loadHabits() async {
    _isLoading = true;
    notifyListeners();

    _habits = await _repository.getHabits();
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loadCompletedHabits() async {
    _completedHabits = await _repository.getCompletedHabits();
    notifyListeners();
  }

  Future<void> addHabit(Habit habit) async {
    await _repository.addHabit(habit);
    _habits.add(habit);
    notifyListeners();
  }

  Future<void> updateHabit(Habit habit) async {
    await _repository.updateHabit(habit);
    final index = _habits.indexWhere((h) => h.id == habit.id);
    if (index != -1) {
      _habits[index] = habit;
      notifyListeners();
    }
  }

  Future<void> deleteHabit(String habitId) async {
    await _repository.deleteHabit(habitId);
    _habits.removeWhere((habit) => habit.id == habitId);
    
    // Cancel any notifications for this habit
    await _notificationService.cancelNotification(habitId.hashCode);
    
    notifyListeners();
  }

  Future<void> markHabitComplete(String habitId) async {
    final today = DateTime.now();
    await _repository.markHabitComplete(habitId, today);
    await _loadCompletedHabits();
    
    // Show completion notification
    final habit = _habits.firstWhere((h) => h.id == habitId);
    await _notificationService.showInstantNotification(
      id: DateTime.now().millisecondsSinceEpoch,
      title: 'Habit Completed!',
      body: 'Great job completing "${habit.name}"!',
    );
  }

  Future<void> markHabitIncomplete(String habitId) async {
    final today = DateTime.now();
    await _repository.markHabitIncomplete(habitId, today);
    await _loadCompletedHabits();
  }

  Future<void> saveUser(User user) async {
    await _repository.saveUser(user);
    _currentUser = user;
    notifyListeners();
  }

  Future<void> logout() async {
    _currentUser = null;
    _habits = [];
    _completedHabits = {};
    notifyListeners();
  }

  Future<void> scheduleNotification(Habit habit, TimeOfDay time) async {
    if (await _notificationService.requestPermissions()) {
      final now = DateTime.now();
      final scheduledTime = DateTime(
        now.year,
        now.month,
        now.day,
        time.hour,
        time.minute,
      );

      await _notificationService.scheduleNotification(
        id: habit.id.hashCode,
        title: 'Habit Reminder',
        body: 'Time to complete "${habit.name}"!',
        scheduledTime: scheduledTime,
      );
    }
  }

  Future<void> cancelNotification(String habitId) async {
    await _notificationService.cancelNotification(habitId.hashCode);
  }

  bool isHabitCompletedToday(String habitId) {
    final today = DateTime.now();
    final completedToday = _completedHabits[_getDateKey(today)] ?? [];
    return completedToday.contains(habitId);
  }

  int getCompletionStreak(String habitId) {
    int streak = 0;
    final today = DateTime.now();
    
    for (int i = 0; i < 365; i++) {
      final date = today.subtract(Duration(days: i));
      final dateKey = _getDateKey(date);
      final completedOnDate = _completedHabits[dateKey]?.contains(habitId) ?? false;
      
      if (completedOnDate) {
        streak++;
      } else {
        break;
      }
    }
    
    return streak;
  }

  double getCompletionRate(String habitId, int days) {
    int completedDays = 0;
    final today = DateTime.now();
    
    for (int i = 0; i < days; i++) {
      final date = today.subtract(Duration(days: i));
      final dateKey = _getDateKey(date);
      if (_completedHabits[dateKey]?.contains(habitId) ?? false) {
        completedDays++;
      }
    }
    
    return days > 0 ? completedDays / days : 0.0;
  }

  Map<String, int> getWeeklyProgress() {
    final Map<String, int> progress = {};
    final today = DateTime.now();
    final startOfWeek = today.subtract(Duration(days: today.weekday - 1));
    
    for (int i = 0; i < 7; i++) {
      final date = startOfWeek.add(Duration(days: i));
      final dateKey = _getDateKey(date);
      final completedHabits = _completedHabits[dateKey] ?? [];
      progress[dateKey] = completedHabits.length;
    }
    
    return progress;
  }

  String _getDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}