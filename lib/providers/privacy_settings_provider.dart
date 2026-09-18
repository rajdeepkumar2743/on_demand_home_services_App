import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrivacySettingsProvider with ChangeNotifier {
  bool _privateProfile = true;
  bool _dataSharing = false;
  bool _locationTracking = true;

  bool get privateProfile => _privateProfile;
  bool get dataSharing => _dataSharing;
  bool get locationTracking => _locationTracking;

  PrivacySettingsProvider() {
    _loadPreferences();
  }

  // Load settings from shared preferences
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _privateProfile = prefs.getBool('privateProfile') ?? true;
    _dataSharing = prefs.getBool('dataSharing') ?? false;
    _locationTracking = prefs.getBool('locationTracking') ?? true;
    notifyListeners();
  }

  // Save settings to shared preferences
  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('privateProfile', _privateProfile);
    await prefs.setBool('dataSharing', _dataSharing);
    await prefs.setBool('locationTracking', _locationTracking);
  }

  // Update privacy settings
  void setPrivateProfile(bool value) {
    _privateProfile = value;
    _savePreferences();
    notifyListeners();
  }

  void setDataSharing(bool value) {
    _dataSharing = value;
    _savePreferences();
    notifyListeners();
  }

  void setLocationTracking(bool value) {
    _locationTracking = value;
    _savePreferences();
    notifyListeners();
  }
}
