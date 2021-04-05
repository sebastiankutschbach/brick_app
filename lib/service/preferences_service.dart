import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService extends ChangeNotifier {
  SharedPreferences _sharedPrefs;
  Map<String, dynamic> _settings;

  initPreferences() async {
    _sharedPrefs = await SharedPreferences.getInstance()
        .then((value) => _sharedPrefs = value);
    String settingsJson = _sharedPrefs.getString('settings') ?? '{}';
    _settings = jsonDecode(settingsJson);
  }

  set(String key, String value) {
    _sharedPrefs.setString(key, value);
    notifyListeners();
  }

  String get(String key) => _sharedPrefs.getString(key);

  String get apiKey => _settings['apiKey'] as String ?? '';
  set apiKey(String apiKey) {
    _settings['apiKey'] = apiKey;
    _persist();
    notifyListeners();
  }

  String get userToken => _settings['userToken'] as String ?? '';
  set userToken(String userToken) {
    _settings['userToken'] = userToken;
    _persist();
    notifyListeners();
  }

  Future<void> _persist() async {
    await _sharedPrefs.setString('settings', jsonEncode(_settings));
  }
}
