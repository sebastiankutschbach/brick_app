import 'package:brick_app/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    String? username;
    String? password;
    String? apiKey;

    setUp(() async {
      await dotenv.load();
      username = dotenv.env['IT_USERNAME'];
      password = dotenv.env['IT_PASSWORD'];
      apiKey = dotenv.env['IT_APIKEY'];
    });

    testWidgets('login is possible', (WidgetTester tester) async {
      expect(username, isNotNull,
          reason: 'IT_USERNAME not set as env variable');
      expect(password, isNotNull,
          reason: 'IT_PASSWORD not set as env variable');
      expect(apiKey, isNotNull, reason: 'IT_APIKEY not set as env variable');

      app.main();
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('username')), username!);
      await tester.enterText(find.byKey(const Key('password')), password!);

      await tester.tap(find.byKey(const Key('brickAppBarSettings')));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('apiKey')), apiKey!);

      await tester.pageBack();
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('login')));

      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(find.byKey(const Key('setList')), findsOneWidget);
    });
  });
}
