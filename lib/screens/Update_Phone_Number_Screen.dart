import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/account_settings_provider.dart';

class UpdatePhoneNumberScreen extends StatefulWidget {
  @override
  _UpdatePhoneNumberScreenState createState() => _UpdatePhoneNumberScreenState();
}

class _UpdatePhoneNumberScreenState extends State<UpdatePhoneNumberScreen> {
  final _phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<AccountSettingsProvider>(context, listen: false);
      _phoneNumberController.text = provider.phoneNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AccountSettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Update Phone Number'),
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
              controller: _phoneNumberController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                hintText: 'Enter your phone number', // Added hintText here
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                final phoneNumber = _phoneNumberController.text.trim();

                if (phoneNumber.isNotEmpty) {
                  provider.updatePhoneNumber(phoneNumber);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Phone number updated')),
                  );
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill out the field')),
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
