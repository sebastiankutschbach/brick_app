import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
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
  }

  String get(String key) => _sharedPrefs.getString(key);

  String get apiKey => _settings['apiKey'] as String ?? '';
  set apiKey(String apiKey) {
    _settings['apiKey'] = apiKey;
    _persist();
  }

  void _persist() {
    _sharedPrefs.setString('settings', jsonEncode(_settings));
  }
}
