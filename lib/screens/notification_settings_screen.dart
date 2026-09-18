import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/notification_settings_provider.dart';

class NotificationSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<NotificationSettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Settings'),
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
              'Notification Preferences',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            SwitchListTile(
              title: Text('Promotional Notifications'),
              subtitle: Text('Receive notifications about special offers, promotions, and discounts.'),
              value: settingsProvider.promotionalNotifications,
              onChanged: (bool value) {
                settingsProvider.setPromotionalNotifications(value);
              },
            ),
            SizedBox(height: 16),
            SwitchListTile(
              title: Text('Service Updates'),
              subtitle: Text('Get updates and information about the services you are using.'),
              value: settingsProvider.serviceUpdates,
              onChanged: (bool value) {
                settingsProvider.setServiceUpdates(value);
              },
            ),
            SizedBox(height: 16),
            SwitchListTile(
              title: Text('Reminders'),
              subtitle: Text('Receive reminders for upcoming appointments, bookings, and deadlines.'),
              value: settingsProvider.reminders,
              onChanged: (bool value) {
                settingsProvider.setReminders(value);
              },
            ),
            SizedBox(height: 32),
            Text(
              'Notification Policy',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'We use notifications to keep you informed about important updates, offers, and reminders. You can manage your notification preferences at any time.',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Notification settings updated')),
                );
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
