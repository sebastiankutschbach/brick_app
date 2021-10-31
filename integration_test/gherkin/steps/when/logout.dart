import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric logout() {
  return when<FlutterWorld>(
    'I logout',
    (context) async {
      await context.world.appDriver.tap(
        context.world.appDriver.findBy('brickAppBarLogout', FindType.key),
      );
    },
  );
}
