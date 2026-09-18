import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/account_settings_provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AccountSettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
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
              controller: _oldPasswordController,
              decoration: InputDecoration(labelText: 'Old Password'),
              obscureText: true,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _newPasswordController,
              decoration: InputDecoration(labelText: 'New Password'),
              obscureText: true,
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                final oldPassword = _oldPasswordController.text.trim();
                final newPassword = _newPasswordController.text.trim();

                if (oldPassword.isNotEmpty && newPassword.isNotEmpty) {
                  // Check if old password matches
                  bool isPasswordValid = await provider.validateOldPassword(oldPassword);

                  if (isPasswordValid) {
                    provider.updatePassword(newPassword);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Password updated')),
                    );
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Old password is not correct')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill out all fields')),
                  );
                }
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
