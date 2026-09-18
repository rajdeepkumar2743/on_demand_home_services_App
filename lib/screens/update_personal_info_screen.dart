import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/account_settings_provider.dart';

class UpdatePersonalInfoScreen extends StatefulWidget {
  @override
  _UpdatePersonalInfoScreenState createState() => _UpdatePersonalInfoScreenState();
}

class _UpdatePersonalInfoScreenState extends State<UpdatePersonalInfoScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<AccountSettingsProvider>(context, listen: false);
      _nameController.text = provider.name;
      _emailController.text = provider.email;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AccountSettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Update Personal Information'),
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
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                hintText: 'Enter your Name', // Added hintText here
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your Email', // Optional: you can add hintText here as well if needed
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                final name = _nameController.text.trim();
                final email = _emailController.text.trim();

                if (name.isNotEmpty && email.isNotEmpty) {
                  provider.updateName(name);
                  provider.updateEmail(email);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Personal information updated')),
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
          ],
        ),
      ),
    );
  }
}
