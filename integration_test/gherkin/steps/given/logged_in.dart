import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric loggedIn() {
  return given<FlutterWorld>(
    'A logged in user',
    (context) async {
      await dotenv.load();
      String? username = dotenv.env['IT_USERNAME'];
      String? password = dotenv.env['IT_PASSWORD'];
      String? apiKey = dotenv.env['IT_APIKEY'];

      context.expect(username, isNotNull,
          reason: 'IT_USERNAME not set in .env file');
      context.expect(password, isNotNull,
          reason: 'IT_PASSWORD not set in .env file');
      context.expect(apiKey, isNotNull,
          reason: 'IT_APIKEY not set in .env file');

      await context.world.appDriver.waitForAppToSettle();

      await context.world.appDriver.enterText(
          context.world.appDriver.findBy('username', FindType.key), username!);
      await context.world.appDriver.enterText(
          context.world.appDriver.findBy('password', FindType.key), password!);

      await context.world.appDriver.tap(
          context.world.appDriver.findBy('brickAppBarSettings', FindType.key));
      await context.world.appDriver.waitForAppToSettle();

      await context.world.appDriver.enterText(
          context.world.appDriver.findBy('apiKey', FindType.key), apiKey!);

      await context.world.appDriver.pageBack();
      await context.world.appDriver.waitForAppToSettle();

      await context.world.appDriver
          .tap(context.world.appDriver.findBy('login', FindType.key));

      await context.world.appDriver
          .waitForAppToSettle(duration: const Duration(seconds: 2));

      await context.world.appDriver.waitForAppToSettle();
    },
    configuration: StepDefinitionConfiguration()
      ..timeout = const Duration(seconds: 30),
  );
}
