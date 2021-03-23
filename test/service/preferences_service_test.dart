import 'package:brick_app/service/preferences_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

main() {
  PreferencesService _preferencesService;

  setUp(() async {
    SharedPreferences.setMockInitialValues({'testKey': 'testValue'});
    _preferencesService = PreferencesService();
    await _preferencesService.initPreferences();
  });

  test('universal set', () {
    _preferencesService.set('testKey', 'newValue');
    expect(_preferencesService.get('testKey'), 'newValue');
  });

  test('universal get', () {
    expect(_preferencesService.get('testKey'), 'testValue');
    expect(_preferencesService.get('notExistingKey'), isNull);
  });

  test('get api key', () async {
    // not set yet
    expect(_preferencesService.apiKey, '');

    SharedPreferences.setMockInitialValues({'settings': '{"apiKey": "myKey"}'});
    _preferencesService = PreferencesService();
    await _preferencesService.initPreferences();

    expect(_preferencesService.apiKey, 'myKey');
  });

  test('set api key', () async {
    _preferencesService.apiKey = 'myKey';
    expect(_preferencesService.apiKey, 'myKey');
  });
}
