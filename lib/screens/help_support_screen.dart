import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help & Support'),
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
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            leading: Icon(Icons.question_answer),
            title: Text('FAQ'),
            subtitle: Text('Frequently Asked Questions'),
            onTap: () {
              Navigator.pushNamed(context, '/faq');
            },
          ),
          ListTile(
            leading: Icon(Icons.contact_support),
            title: Text('Contact Us'),
            subtitle: Text('Reach out to our support team'),
            onTap: () {
              Navigator.pushNamed(context, '/contactUs');
            },
          ),
          ListTile(
            leading: Icon(Icons.report_problem),
            title: Text('Report a Problem'),
            subtitle: Text('Report issues or bugs'),
            onTap: () {
              Navigator.pushNamed(context, '/reportProblem');
            },
          ),
          ListTile(
            leading: Icon(Icons.feedback),
            title: Text('Feedback'),
            subtitle: Text('Give us your feedback'),
            onTap: () {
              Navigator.pushNamed(context, '/feedback');
            },
          ),
          ListTile(
            leading: Icon(Icons.shield),
            title: Text('Privacy Policy'),
            subtitle: Text('Read our privacy policy'),
            onTap: () {
              Navigator.pushNamed(context, '/privacyPolicy');
            },
          ),
          ListTile(
            leading: Icon(Icons.gavel),
            title: Text('Terms of Service'),
            subtitle: Text('Read our terms of service'),
            onTap: () {
              Navigator.pushNamed(context, '/termsOfService');
            },
          ),
        ],
      ),
    );
  }
}
