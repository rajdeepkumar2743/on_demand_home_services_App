import 'package:flutter/material.dart';

class FAQScreen extends StatelessWidget {
  final List<Map<String, String>> faqs = [
    {'question': 'How do I reset my password?', 'answer': 'Go to the account settings and select "Change Password".'},
    {'question': 'How can I contact support?', 'answer': 'Use the "Contact Us" section in the Help & Support menu.'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Frequently Asked Questions'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          return ExpansionTile(
            title: Text(faqs[index]['question']!),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(faqs[index]['answer']!),
              ),
            ],
          );
        },
      ),
    );
  }
}
