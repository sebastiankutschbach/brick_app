import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric tapWidget() {
  return when1<String, FlutterWorld>(
    'I tap the widget with the key {string}',
    (key, context) async {
      await context.world.appDriver.scrollUntilVisible(
          context.world.appDriver.findBy(key, FindType.key));
      await context.world.appDriver.tap(
        context.world.appDriver.findBy(key, FindType.key),
      );
      await context.world.appDriver.waitForAppToSettle();
    },
  );
}
