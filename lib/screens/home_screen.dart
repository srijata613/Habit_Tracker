import 'package:flutter/material.dart';
import 'configure_habits_screen.dart';
import 'menu_screen.dart';
import 'quote_display_widget.dart'; // Make sure this import exists

class HomeScreen extends StatelessWidget {
  Future<Map<String, String>> fetchDailyQuote() async {
    await Future.delayed(Duration(seconds: 1));
    return {
      'quote': 'The only way to do great work is to love what you do.',
      'author': 'Steve Jobs'
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Habit Tracker'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
      ),
      drawer: Drawer(
        child: MenuScreen(),
      ),
      body: FutureBuilder<Map<String, String>>(
        future: fetchDailyQuote(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching quote'));
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                QuoteDisplayWidget(
                  quote: snapshot.data!['quote']!,
                  author: snapshot.data!['author']!,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Welcome to Habit Tracker!',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                // Add other widgets below as needed
              ],
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ConfigureHabitsScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
