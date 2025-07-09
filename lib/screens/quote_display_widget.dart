import 'package:flutter/material.dart';

// Dummy habit templates
final List<String> habitTemplates = ['Exercise', 'Meditate', 'Read'];

class QuoteDisplayWidget extends StatelessWidget {
  final String quote;
  final String author;

  const QuoteDisplayWidget({required this.quote, required this.author, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              quote,
              style: TextStyle(fontSize: 18.0, fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 10.0),
            Text(
              '- $author',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class TemplateSelectionScreen extends StatelessWidget {
  final List<String> templates;

  const TemplateSelectionScreen({required this.templates, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select a Template')),
      body: ListView.builder(
        itemCount: templates.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(templates[index]),
            onTap: () {
              Navigator.pop(context, templates[index]);
            },
          );
        },
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedTemplate;

  Future<Map<String, String>> fetchDailyQuote() async {
    await Future.delayed(Duration(seconds: 1)); // Simulate API delay
    return {
      'quote': 'The only way to do great work is to love what you do.',
      'author': 'Steve Jobs'
    };
  }

  void _selectTemplate() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            TemplateSelectionScreen(templates: habitTemplates),
      ),
    );

    if (result != null) {
      setState(() {
        selectedTemplate = result;
        // TODO: Add logic to store or use selectedTemplate
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Habit Tracker')),
      body: FutureBuilder<Map<String, String>>(
        future: fetchDailyQuote(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching quote'));
          } else {
            return SingleChildScrollView(
              child: Column(
                children: [
                  QuoteDisplayWidget(
                    quote: snapshot.data!['quote']!,
                    author: snapshot.data!['author']!,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _selectTemplate,
                    child: Text('Select from Templates'),
                  ),
                  if (selectedTemplate != null)
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Selected Template: $selectedTemplate',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
