import 'package:brick_app/model/rebrickable_model.dart';
import 'package:brick_app/pages/login_page.dart';
import 'package:brick_app/service/preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

class RebrickableModelMock extends Mock implements RebrickableModel {}

class PreferencesServiceMock extends Mock implements PreferencesService {}

class NavigatorObserverMock extends Mock implements NavigatorObserver {}

void main() {
  createApp(bool loginSucces,
          {RebrickableModelMock rebrickableModelMock,
          NavigatorObserverMock navigatorObserverMock}) =>
      MaterialApp(
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider<RebrickableModel>(create: (context) {
              final modelMock = rebrickableModelMock ?? RebrickableModelMock();
              when(modelMock.login('username', 'password', 'apiKey'))
                  .thenAnswer((_) async => loginSucces);
              return modelMock;
            }),
            Provider<PreferencesService>(create: (_) {
              final service = PreferencesServiceMock();
              when(service.apiKey).thenReturn('apiKey');
              return service;
            }),
          ],
          child: LoginPage(),
        ),
        navigatorObservers:
            navigatorObserverMock != null ? [navigatorObserverMock] : [],
      );
  group('smoke test', () {
    testWidgets(
        'Finds title, login button, username and password fields on login page',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: createApp(true)));

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Rebrickable Login'), findsOneWidget);

      expect(find.byKey(Key('username')), findsOneWidget);
      expect(find.byKey(Key('password')), findsOneWidget);

      expect(find.byKey(Key('login')), findsOneWidget);
    });
  });

  group('input test', () {
    testWidgets('Does not accept empty username', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: createApp(true)));

      expect(find.byKey(Key('username')), findsOneWidget);
      await tester.tap(find.text('Login'));

      await tester.pumpAndSettle();

      expect(find.text('Username cannot be empty'), findsOneWidget);
    });

    testWidgets('Does not accept empty password', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: createApp(true)));

      await tester.enterText(find.byKey(Key('username')), 'myUsername');
      await tester.tap(find.byKey(Key('login')));

      await tester.pumpAndSettle();

      expect(find.text('Password cannot be empty'), findsOneWidget);
    });
  });

  group('login test', () {
    testWidgets('Tries to login when username and password given',
        (WidgetTester tester) async {
      final rebrickableModelMock = RebrickableModelMock();
      await tester.pumpWidget(MaterialApp(
          home: createApp(true, rebrickableModelMock: rebrickableModelMock)));

      await tester.enterText(find.byKey(Key('username')), 'username');
      await tester.enterText(find.byKey(Key('password')), 'password');
      await tester.tap(find.byKey(Key('login')));

      await tester.pumpAndSettle();

      verify(rebrickableModelMock.login('username', 'password', 'apiKey'));
    });

    group('navigation test', () {
      testWidgets('Navigates to overview page when login was successful',
          (WidgetTester tester) async {
        final modelMock = RebrickableModelMock();
        final observerMock = NavigatorObserverMock();
        when(modelMock.login('username', 'password', 'apiKey'))
            .thenAnswer((_) async => true);
        await tester.pumpWidget(MaterialApp(
            home: createApp(true,
                rebrickableModelMock: modelMock,
                navigatorObserverMock: observerMock)));

        await tester.enterText(find.byKey(Key('username')), 'username');
        await tester.enterText(find.byKey(Key('password')), 'password');
        await tester.tap(find.byKey(Key('login')));

        await tester.pumpAndSettle();

        verify(observerMock.didPush(captureAny, any)).called(2);
      });
    });
    testWidgets(
        'Does not navigate to overview page when login was unsuccessful',
        (WidgetTester tester) async {
      final modelMock = RebrickableModelMock();
      final observerMock = NavigatorObserverMock();
      when(modelMock.login('username', 'password', 'apiKey'))
          .thenAnswer((_) async => false);
      await tester.pumpWidget(MaterialApp(
          home: createApp(false,
              rebrickableModelMock: modelMock,
              navigatorObserverMock: observerMock)));

      await tester.enterText(find.byKey(Key('username')), 'username');
      await tester.enterText(find.byKey(Key('password')), 'password');
      await tester.tap(find.byKey(Key('login')));

      await tester.pumpAndSettle();

      verify(observerMock.didPush(captureAny, any)).called(1);
    });
  });
}
