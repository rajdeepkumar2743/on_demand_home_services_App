import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/account_settings_provider.dart';
import '../providers/user_provider.dart';

class AccountSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final accountProvider = Provider.of<AccountSettingsProvider>(context);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Account Settings'),
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
            leading: Icon(Icons.person),
            title: Text('Personal Information'),
            subtitle: Text(
                accountProvider.name.isNotEmpty
                    ? 'Name: ${accountProvider.name}\nEmail: ${accountProvider.email}'
                    : 'Name: Enter your Name\nEmail: ${accountProvider.email}'
            ),
            onTap: () {
              _showPersonalInfoDialog(context, accountProvider);
            },
          ),
          ListTile(
            leading: Icon(Icons.phone),
            title: Text('Phone Number'),
            subtitle: Text(
                accountProvider.phoneNumber.isNotEmpty
                    ? 'Phone: ${accountProvider.phoneNumber}'
                    : 'Phone: Enter your Phone number'
            ),
            onTap: () {
              _showPhoneNumberDialog(context, accountProvider);
            },
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Change Password'),
            subtitle: Text('Change your account password'),
            onTap: () {
              Navigator.pushNamed(context, '/changePassword');
            },
          ),
          ListTile(
            leading: Icon(Icons.email),
            title: Text('Email Preferences'),
            subtitle: Text('Email notifications: ${accountProvider.emailPreferences ? "Enabled" : "Disabled"}'),
            onTap: () {
              Navigator.pushNamed(context, '/emailPreferences');
            },
          ),
          ListTile(
            leading: Icon(Icons.security),
            title: Text('Security Settings'),
            subtitle: Text('Two-factor authentication: ${accountProvider.twoFactorAuth ? "Enabled" : "Disabled"}'),
            onTap: () {
              Navigator.pushNamed(context, '/securitySettings');
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            subtitle: Text('Sign out of your account'),
            onTap: () {
              // Perform logout logic
              userProvider.logout();
              accountProvider.logout();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Logging out...')),
              );

              // Navigate to login page
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
          ),
        ],
      ),
    );
  }

  void _showPersonalInfoDialog(BuildContext context, AccountSettingsProvider provider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final _nameController = TextEditingController(text: provider.name);
        final _emailController = TextEditingController(text: provider.email);

        return AlertDialog(
          title: Text('Update Personal Information'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Enter your Name',
                  labelText: 'Name',
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Enter your Email',
                  labelText: 'Email',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final name = _nameController.text.trim();
                final email = _emailController.text.trim();

                if (name.isNotEmpty && email.isNotEmpty) {
                  provider.updateName(name);
                  provider.updateEmail(email);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Personal information updated successfully')),
                  );
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill out all fields')),
                  );
                }
              },
              child: Text('Save Changes'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showPhoneNumberDialog(BuildContext context, AccountSettingsProvider provider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final _phoneNumberController = TextEditingController(text: provider.phoneNumber);

        return AlertDialog(
          title: Text('Update Phone Number'),
          content: TextField(
            controller: _phoneNumberController,
            decoration: InputDecoration(
              hintText: 'Enter your Phone number',
              labelText: 'Phone Number',
            ),
            keyboardType: TextInputType.phone,
          ),
          actions: [
            TextButton(
              onPressed: () {
                final phoneNumber = _phoneNumberController.text.trim();

                if (phoneNumber.isNotEmpty) {
                  provider.updatePhoneNumber(phoneNumber);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Phone number updated successfully')),
                  );
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a valid phone number')),
                  );
                }
              },
              child: Text('Save Changes'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
