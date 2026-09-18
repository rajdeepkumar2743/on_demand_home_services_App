import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/account_settings_provider.dart';

class EmailPreferencesScreen extends StatefulWidget {
  @override
  _EmailPreferencesScreenState createState() => _EmailPreferencesScreenState();
}

class _EmailPreferencesScreenState extends State<EmailPreferencesScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AccountSettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Email Preferences'),
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
            SwitchListTile(
              title: Text('Receive Email Notifications'),
              value: provider.emailPreferences,
              onChanged: (bool value) {
                provider.updateEmailPreferences(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
