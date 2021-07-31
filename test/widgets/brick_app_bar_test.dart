import 'package:brick_app/service/preferences_service.dart';
import 'package:brick_app/widgets/brick_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'brick_app_bar_test.mocks.dart';

@GenerateMocks([PreferencesService],
    customMocks: [MockSpec<NavigatorObserver>(returnNullOnMissingStub: true)])
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
              Text('title'),
              showLogoutButton: showLogoutButton,
            ),
          ),
          navigatorObservers: [
            navigatorObserverMock ?? MockNavigatorObserver()
          ],
        ),
      );

  group('logout', () {
    testWidgets('logout button is not shown if showLogoutButton is false',
        (tester) async {
      await tester.pumpWidget(_createApp(showLogoutButton: false));

      expect(find.byKey(ObjectKey('brickAppBarSettings')), findsOneWidget);
      expect(find.byKey(ObjectKey('brickAppBarLogout')), findsNothing);
    });

    testWidgets('logout button is shown if showLogoutButton is true',
        (tester) async {
      await tester.pumpWidget(_createApp(showLogoutButton: true));

      expect(find.byKey(ObjectKey('brickAppBarSettings')), findsOneWidget);
      expect(find.byKey(ObjectKey('brickAppBarLogout')), findsOneWidget);
    });

    testWidgets('logout triggers reset of user_token', (tester) async {
      final preferencesServiceMock = MockPreferencesService();
      await tester.pumpWidget(
          _createApp(preferencesServiceMock: preferencesServiceMock));

      await tester.tap(find.byKey(ObjectKey('brickAppBarLogout')));

      fail('fix line below');
      //verify(preferencesServiceMock.userToken = null).called(1);
    });
  });

  group('settings', () {
    testWidgets('tap on settings button navigates to settings page',
        (tester) async {
      final observerMock = MockNavigatorObserver();
      await tester.pumpWidget(_createApp(navigatorObserverMock: observerMock));

      await tester.tap(find.byKey(ObjectKey('brickAppBarSettings')));
      await tester.pump();

      fail('fix line below');
      //verify(observerMock.didPush(captureAny, any)).called(2);
    });
  });
}
