import 'package:brick_app/pages/settings_page.dart';
import 'package:brick_app/service/preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

import '../mocks.dart';

main() {
  final preferencesServiceMock = MockPreferencesService();
  when(() => preferencesServiceMock.apiKey).thenReturn('');
  final app = MaterialApp(
    home: ChangeNotifierProvider<PreferencesService>(
      create: (context) => preferencesServiceMock,
      child: const SettingsPage(),
    ),
  );
  group('smoke test', () {
    testWidgets('has a text field for api key', (tester) async {
      await tester.pumpWidget(MaterialApp(home: app));

      expect(find.byKey(const Key('apiKey')), findsOneWidget);
    });
  });

  group('api key', () {
    testWidgets('does persist api key', (tester) async {
      await tester.pumpWidget(MaterialApp(home: app));
      await tester.enterText(find.byKey(const Key('apiKey')), 'myKey');
      await tester.pumpAndSettle();

      verify(() => preferencesServiceMock.apiKey = 'myKey');
    });
  });
}
