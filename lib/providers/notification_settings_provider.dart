import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSettingsProvider with ChangeNotifier {
  bool _promotionalNotifications = true;
  bool _serviceUpdates = true;
  bool _reminders = true;

  bool get promotionalNotifications => _promotionalNotifications;
  bool get serviceUpdates => _serviceUpdates;
  bool get reminders => _reminders;

  NotificationSettingsProvider() {
    _loadSettings();
  }

  // Load settings from shared preferences
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _promotionalNotifications = prefs.getBool('promotionalNotifications') ?? true;
    _serviceUpdates = prefs.getBool('serviceUpdates') ?? true;
    _reminders = prefs.getBool('reminders') ?? true;
    notifyListeners();
  }

  // Save settings to shared preferences
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('promotionalNotifications', _promotionalNotifications);
    await prefs.setBool('serviceUpdates', _serviceUpdates);
    await prefs.setBool('reminders', _reminders);
  }

  // Update notification preferences
  void setPromotionalNotifications(bool value) {
    _promotionalNotifications = value;
    _saveSettings();
    notifyListeners();
  }

  void setServiceUpdates(bool value) {
    _serviceUpdates = value;
    _saveSettings();
    notifyListeners();
  }

  void setReminders(bool value) {
    _reminders = value;
    _saveSettings();
    notifyListeners();
  }
}
