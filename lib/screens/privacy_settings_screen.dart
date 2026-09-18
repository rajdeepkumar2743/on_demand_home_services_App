import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/privacy_settings_provider.dart';

class PrivacySettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final privacyProvider = Provider.of<PrivacySettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Settings'),
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
              'Profile Privacy',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SwitchListTile(
              title: Text('Private Profile'),
              subtitle: Text('Only you can see your profile details.'),
              value: privacyProvider.privateProfile,
              onChanged: (bool value) {
                privacyProvider.setPrivateProfile(value);
              },
            ),
            SizedBox(height: 16),
            Text(
              'Data Sharing',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SwitchListTile(
              title: Text('Share Data with Partners'),
              subtitle: Text('Allow sharing your data with our partners for better service.'),
              value: privacyProvider.dataSharing,
              onChanged: (bool value) {
                privacyProvider.setDataSharing(value);
              },
            ),
            SizedBox(height: 16),
            Text(
              'Location Tracking',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SwitchListTile(
              title: Text('Enable Location Tracking'),
              subtitle: Text('Allow the app to track your location for better service recommendations.'),
              value: privacyProvider.locationTracking,
              onChanged: (bool value) {
                privacyProvider.setLocationTracking(value);
              },
            ),
            SizedBox(height: 32),
            Text(
              'Privacy Policy',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Your privacy is important to us. We use your data to enhance your experience and provide better services. For more information, please review our Privacy Policy.',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Privacy settings updated')),
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
