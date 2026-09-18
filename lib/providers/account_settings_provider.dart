import 'package:flutter/foundation.dart';

class AccountSettingsProvider with ChangeNotifier {
  // Existing properties
  String _name = '';
  String _email = '';
  String _phoneNumber = '';
  String _password = ''; // Add password if needed
  bool _emailPreferences = true; // Example preference
  bool _twoFactorAuth = false; // Example security setting

  // Getters
  String get name => _name;
  String get email => _email;
  String get phoneNumber => _phoneNumber;
  String get password => _password;
  bool get emailPreferences => _emailPreferences;
  bool get twoFactorAuth => _twoFactorAuth;

  // Update methods
  void updateName(String newName) {
    _name = newName;
    notifyListeners();
  }

  void updateEmail(String newEmail) {
    _email = newEmail;
    notifyListeners();
  }

  void updatePhoneNumber(String newPhoneNumber) {
    _phoneNumber = newPhoneNumber;
    notifyListeners();
  }

  void updatePassword(String newPassword) {
    _password = newPassword;
    notifyListeners();
  }

  void updateEmailPreferences(bool preference) {
    _emailPreferences = preference;
    notifyListeners();
  }

  void updateTwoFactorAuth(bool enabled) {
    _twoFactorAuth = enabled;
    notifyListeners();
  }

  void logout() {
    // Clear account settings if needed
    _name = '';
    _email = '';
    _phoneNumber = '';
    _password = '';
    _emailPreferences = true;
    _twoFactorAuth = false;
    notifyListeners();
  }

  // New method to validate old password
  Future<bool> validateOldPassword(String oldPassword) async {
    // Simulate a delay for asynchronous operation
    await Future.delayed(Duration(milliseconds: 100));
    return oldPassword == _password;
  }
}
