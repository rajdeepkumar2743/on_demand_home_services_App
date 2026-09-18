import 'package:flutter/material.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback'),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _feedbackController,
              decoration: InputDecoration(labelText: 'Your Feedback'),
              maxLines: 5,
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Logic to submit feedback
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Thank you for your feedback!')),
                );
                // Clear the field after submission
                _feedbackController.clear();
              },
              child: Text('Submit Feedback'),
            ),
          ],
        ),
      ),
    );
  }
}
