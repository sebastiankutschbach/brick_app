import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric expectWidgetVisible() {
  return then1<String, FlutterWorld>(
    'I expect the widget {string} to be visible',
    (key, context) async {
      context.expect(
          context.world.appDriver.findBy(key, FindType.key), findsWidgets);
    },
  );
}
