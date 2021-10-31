import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'package:shared_preferences/shared_preferences.dart';

StepDefinitionGeneric freshApp() {
  return given<FlutterWorld>(
    'A fresh app',
    (context) async {
      final sharedPrefs = await SharedPreferences.getInstance();
      await sharedPrefs.clear();
    },
  );
}
