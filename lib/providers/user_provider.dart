import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  String _userEmail = '';
  String _userPassword = '';

  String get userEmail => _userEmail;
  String get userPassword => _userPassword;

  UserProvider() {
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    _userEmail = prefs.getString('email') ?? '';
    _userPassword = prefs.getString('password') ?? '';
    notifyListeners();
  }

  Future<void> setUser(String email, String password) async {
    _userEmail = email;
    _userPassword = password;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('password', password);

    notifyListeners();
  }

  Future<void> logout() async {
    _userEmail = '';
    _userPassword = '';

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('password');

    notifyListeners();
  }
}
