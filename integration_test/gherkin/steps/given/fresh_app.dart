import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

const Map<String, String> widgetNameToKeyMapping = {'SetList': 'setList'};

StepDefinitionGeneric freshApp() {
  return given<FlutterWorld>(
    'A fresh app',
    (context) async {},
  );
}
