import 'package:brick_app/pages/settings_page.dart';
import 'package:brick_app/service/preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

class PreferencesServiceMock extends Mock implements PreferencesService {}

main() {
  final preferencesServiceMock = PreferencesServiceMock();
  final app = MaterialApp(
    home: Provider<PreferencesService>(
      create: (context) => preferencesServiceMock,
      child: SettingsPage(),
    ),
  );
  group('smoke test', () {
    testWidgets('has a text field for api key', (tester) async {
      await tester.pumpWidget(MaterialApp(home: app));

      expect(find.byKey(Key('apiKey')), findsOneWidget);
    });
  });

  group('api key', () {
    testWidgets('does persist api key', (tester) async {
      await tester.pumpWidget(MaterialApp(home: app));
      await tester.enterText(find.byKey(Key('apiKey')), 'myKey');
      await tester.pumpAndSettle();

      verify(preferencesServiceMock.apiKey = 'myKey');
    });
  });
}
