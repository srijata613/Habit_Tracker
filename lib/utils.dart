import 'package:flutter/material.dart';

class Utils {
  // Date formatting utilities
  static String formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
  
  static String formatDateForDisplay(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
  
  static String formatDateShort(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}';
  }
  
  static DateTime parseDate(String dateString) {
    final parts = dateString.split('-');
    return DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  }
  
  // Get today's date as string
  static String getTodayString() {
    return formatDate(DateTime.now());
  }
  
  // Check if a date is today
  static bool isToday(DateTime date) {
    final today = DateTime.now();
    return date.year == today.year &&
           date.month == today.month &&
           date.day == today.day;
  }
  
  // Check if a date is yesterday
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
           date.month == yesterday.month &&
           date.day == yesterday.day;
  }
  
  // Get the start of the week (Monday)
  static DateTime getStartOfWeek(DateTime date) {
    final weekday = date.weekday;
    return date.subtract(Duration(days: weekday - 1));
  }
  
  // Get the end of the week (Sunday)
  static DateTime getEndOfWeek(DateTime date) {
    final weekday = date.weekday;
    return date.add(Duration(days: 7 - weekday));
  }
  
  // Get days in current week
  static List<DateTime> getCurrentWeekDays() {
    final now = DateTime.now();
    final startOfWeek = getStartOfWeek(now);
    return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
  }
  
  // Validation utilities
  static bool isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }
  
  static bool isValidPassword(String password) {
    return password.length >= 6;
  }
  
  static bool isValidName(String name) {
    return name.trim().isNotEmpty && name.trim().length >= 2;
  }
  
  static bool isValidAge(String age) {
    final ageInt = int.tryParse(age);
    return ageInt != null && ageInt > 0 && ageInt <= 120;
  }
  
  // Color utilities
  static Color lightenColor(Color color, double amount) {
    assert(amount >= 0 && amount <= 1, 'Amount must be between 0 and 1');
    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness + amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }
  
  static Color darkenColor(Color color, double amount) {
    assert(amount >= 0 && amount <= 1, 'Amount must be between 0 and 1');
    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness - amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }
  
  // Snackbar utilities
  static void showSnackBar(BuildContext context, String message, {
    Color? backgroundColor,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: duration,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  
  static void showSuccessSnackBar(BuildContext context, String message) {
    showSnackBar(context, message, backgroundColor: Colors.green);
  }
  
  static void showErrorSnackBar(BuildContext context, String message) {
    showSnackBar(context, message, backgroundColor: Colors.red);
  }
  
  static void showWarningSnackBar(BuildContext context, String message) {
    showSnackBar(context, message, backgroundColor: Colors.orange);
  }
  
  // Dialog utilities
  static Future<bool> showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    Color? confirmColor,
  }) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: confirmColor != null
                ? TextButton.styleFrom(foregroundColor: confirmColor)
                : null,
            child: Text(confirmText),
          ),
        ],
      ),
    ) ?? false;
  }
  
  // Loading dialog
  static void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
  
  // Habit streak calculation
  static int calculateStreak(List<String> completedDates) {
    if (completedDates.isEmpty) return 0;
    
    final sortedDates = completedDates.map((date) => parseDate(date)).toList();
    sortedDates.sort((a, b) => b.compareTo(a)); // Sort in descending order
    
    int streak = 0;
    DateTime currentDate = DateTime.now();
    
    for (final date in sortedDates) {
      if (isToday(date) || isYesterday(date) || 
          (date.difference(currentDate).inDays == -streak)) {
        streak++;
        currentDate = date;
      } else {
        break;
      }
    }
    
    return streak;
  }
  
  // Generate unique ID
  static String generateUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
  
  // Get greeting based on time of day
  static String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }
  
  // Get motivational message based on progress
  static String getMotivationalMessage(double progress) {
    if (progress >= 0.9) {
      return 'Amazing! You\'re crushing your goals! 🎉';
    } else if (progress >= 0.7) {
      return 'Great job! Keep up the momentum! 🔥';
    } else if (progress >= 0.5) {
      return 'You\'re doing well! Stay consistent! 💪';
    } else if (progress >= 0.3) {
      return 'Good start! Every step counts! 🌟';
    } else {
      return 'You\'ve got this! Start small, dream big! 🚀';
    }
  }
  
  // Format time of day
  static String formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
  
  // Get week progress percentage
  static double getWeeklyProgress(List<String> completedDates) {
    final weekDays = getCurrentWeekDays();
    int completedThisWeek = 0;
    
    for (final day in weekDays) {
      final dayString = formatDate(day);
      if (completedDates.contains(dayString)) {
        completedThisWeek++;
      }
    }
    
    return completedThisWeek / 7.0;
  }
}