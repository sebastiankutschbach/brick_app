import 'dart:io';

import 'package:brick_app/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  final env = Platform.environment;
  print(env.keys);

  group('end-to-end test', () {
    String? username;
    String? password;
    String? apiKey;

    setUp(() {
      final env = Platform.environment;
      print(env.keys);
      username = env['IT_USERNAME'];
      password = env['IT_PASSWORD'];
      apiKey = env['IT_APIKEY'];
    });

    testWidgets('login is possible', (WidgetTester tester) async {
      expect(username, isNotNull,
          reason: 'IT_USERNAME not set as env variable');
      expect(password, isTrue, reason: 'IT_PASSWORD not set as env variable');
      expect(apiKey, isTrue, reason: 'IT_APIKEY not set as env variable');

      app.main();
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(Key('username')), username!);
      await tester.enterText(find.byKey(Key('password')), password!);

      await tester.tap(find.byKey(Key('brickAppBarSettings')));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(Key('apiKey')), apiKey!);

      await tester.pageBack();
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('login')));

      await tester.pumpAndSettle();
      await tester.pump(Duration(seconds: 20));
      expect(find.byKey(Key('setList')), findsOneWidget);
    });
  });
}
