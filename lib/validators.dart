class Validators {
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) return 'Enter username';
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.length < 6) return 'Password too short';
    return null;
  }

  static String? validateAge(String? value) {
    if (value == null || int.tryParse(value) == null) return 'Enter valid age';
    return null;
  }
}
