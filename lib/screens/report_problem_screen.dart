import 'package:flutter/material.dart';

class ReportProblemScreen extends StatefulWidget {
  @override
  _ReportProblemScreenState createState() => _ReportProblemScreenState();
}

class _ReportProblemScreenState extends State<ReportProblemScreen> {
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report a Problem'),
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
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Describe the issue'),
              maxLines: 5,
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Logic to report the problem
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Your report has been submitted!')),
                );
                // Clear the field after submission
                _descriptionController.clear();
              },
              child: Text('Submit Report'),
            ),
          ],
        ),
      ),
    );
  }
}
