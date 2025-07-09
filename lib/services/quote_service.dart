import 'dart:math';

class QuoteService {
  final List<Map<String, String>> _quotes = [
    {'quote': 'The only way to do great work is to love what you do.', 'author': 'Steve Jobs'},
    {'quote': 'Life is what happens when you’re busy making other plans.', 'author': 'John Lennon'},
    {'quote': 'Get busy living or get busy dying.', 'author': 'Stephen King'},
  ];

  Future<Map<String, String>> fetchRandomQuote() async {
    final random = Random();
    final index = random.nextInt(_quotes.length);
    return _quotes[index];
  }
}
