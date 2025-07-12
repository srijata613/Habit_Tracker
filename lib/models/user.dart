class User {
  final String id;
  final String name;
  final String username;
  final String password;
  final int age;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.password,
    required this.age,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'password': password,
      'age': age,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      password: json['password'],
      age: json['age'],
    );
  }
}
