class Habit {
  final String name;
  final String category;
  final String color;
  bool isCompleted;

  Habit({
    required this.name,
    required this.category,
    required this.color,
    this.isCompleted = false,
  });

  // Convert a Habit into a Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'color': color,
      'isCompleted': isCompleted,
    };
  }

  // Create a Habit from a Map
  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      name: map['name'],
      category: map['category'],
      color: map['color'],
      isCompleted: map['isCompleted'],
    );
  }
}
