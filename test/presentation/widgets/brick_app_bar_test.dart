import 'package:brick_app/infrastructure/service/preferences_service.dart';
import 'package:brick_app/presentation/widgets/brick_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

import '../../mocks.dart';

main() {
  Widget _createApp({
    MockPreferencesService? preferencesServiceMock,
    MockNavigatorObserver? navigatorObserverMock,
    bool showLogoutButton = true,
  }) =>
      MultiProvider(
        providers: [
          ChangeNotifierProvider<PreferencesService>(
            create: (_) => preferencesServiceMock ?? MockPreferencesService(),
          ),
        ],
        child: MaterialApp(
          home: Scaffold(
            appBar: BrickAppBar(
              const Text('title'),
              showLogoutButton: showLogoutButton,
            ),
          ),
          navigatorObservers: [
            navigatorObserverMock ?? MockNavigatorObserver()
          ],
        ),
      );

  setUpAll(() {
    registerFallbackValue(MaterialPageRoute(builder: (_) => const Text('')));
  });

  group('logout', () {
    testWidgets('logout button is not shown if showLogoutButton is false',
        (tester) async {
      await tester.pumpWidget(_createApp(showLogoutButton: false));

      expect(find.byKey(const Key('brickAppBarSettings')), findsOneWidget);
      expect(find.byKey(const Key('brickAppBarLogout')), findsNothing);
    });

    testWidgets('logout button is shown if showLogoutButton is true',
        (tester) async {
      await tester.pumpWidget(_createApp(showLogoutButton: true));

      expect(find.byKey(const Key('brickAppBarSettings')), findsOneWidget);
      expect(find.byKey(const Key('brickAppBarLogout')), findsOneWidget);
    });

    testWidgets('logout triggers reset of user_token', (tester) async {
      final preferencesServiceMock = MockPreferencesService();
      await tester.pumpWidget(
          _createApp(preferencesServiceMock: preferencesServiceMock));

      await tester.tap(find.byKey(const Key('brickAppBarLogout')));

      verify(() => preferencesServiceMock.userToken = '').called(1);
    });
  });

  group('settings', () {
    testWidgets('tap on settings button navigates to settings page',
        (tester) async {
      final observerMock = MockNavigatorObserver();
      final preferencesServiceMock = MockPreferencesService();
      when(() => preferencesServiceMock.apiKey).thenReturn('');
      await tester.pumpWidget(_createApp(
          navigatorObserverMock: observerMock,
          preferencesServiceMock: preferencesServiceMock));

      await tester.tap(find.byKey(const Key('brickAppBarSettings')));
      await tester.pump();

      verify(() => observerMock.didPush(captureAny(), any())).called(2);
    });
  });
}
