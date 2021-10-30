import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin/gherkin.dart';

const Map<String, String> widgetNameToKeyMapping = {'SetList': 'setList'};

StepDefinitionGeneric expectVisible() {
  return then1<String, FlutterWorld>(
    'I expect the {string} to be visible',
    (widgetName, context) async {
      expect(
          context.world.appDriver
              .findBy(widgetNameToKeyMapping[widgetName], FindType.key),
          findsWidgets);
    },
  );
}
