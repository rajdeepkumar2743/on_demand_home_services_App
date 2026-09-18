import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
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
            Text(
              'About This App',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'On-Demand Home Services is a mobile application designed to connect users with local professionals for various home services such as plumbing, cleaning, electrical work, and more. Our goal is to provide a seamless and convenient experience for finding and booking trusted professionals in your area.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Features:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '• Easy booking of home services\n'
                  '• Verified professionals with ratings and reviews\n'
                  '• Flexible service subscriptions\n'
                  '• User-friendly interface with modern design\n'
                  '• Real-time notifications and reminders\n'
                  '• Secure and transparent transactions\n',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Developed By:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Team RR\n'
                  'We are a group of passionate developers committed to creating innovative solutions that make life easier. If you have any questions or feedback, feel free to reach out to us.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Contact Us:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Email: support@homservices.com\n'
                  'Phone: (+91) 46458-31940\n'
                  'Website: www.homservices.com\n',
              style: TextStyle(fontSize: 16),
            ),


          ],
        ),
      ),
    );
  }
}
