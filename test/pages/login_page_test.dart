import 'package:brick_app/model/rebrickable_model.dart';
import 'package:brick_app/pages/login_page.dart';
import 'package:brick_app/service/preferences_service.dart';
import 'package:brick_app/widgets/brick_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'login_page_test.mocks.dart';

final userToken = 'myUserToken';

@GenerateMocks([RebrickableModel, PreferencesService],
    customMocks: [MockSpec<NavigatorObserver>(returnNullOnMissingStub: true)])
void main() {
  createApp(bool loginSuccess,
          {MockRebrickableModel? rebrickableModelMock,
          MockNavigatorObserver? navigatorObserverMock,
          PreferencesService? preferencesService}) =>
      MultiProvider(
        providers: [
          ChangeNotifierProvider<RebrickableModel>(create: (_) {
            final modelMock = rebrickableModelMock ?? MockRebrickableModel();
            when(modelMock.login('username', 'password', 'apiKey'))
                .thenAnswer((_) async => loginSuccess ? userToken : '');
            when(modelMock.loginWithToken('userToken', 'apiKey'))
                .thenAnswer((_) async => loginSuccess ? userToken : '');
            return modelMock;
          }),
          ChangeNotifierProvider<PreferencesService>(create: (_) {
            final service = MockPreferencesService();
            when(service.apiKey).thenReturn('');
            when(service.userToken).thenReturn('');
            return preferencesService ?? service;
          }),
        ],
        child: MaterialApp(
          home: LoginPage(),
          navigatorObservers:
              navigatorObserverMock != null ? [navigatorObserverMock] : [],
        ),
      );

  group('smoke test', () {
    testWidgets(
        'Finds title, login button, username and password fields on login page',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: createApp(true)));

      expect(find.byType(BrickAppBar), findsOneWidget);
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
      final rebrickableModelMock = MockRebrickableModel();
      await tester.pumpWidget(MaterialApp(
          home: createApp(true, rebrickableModelMock: rebrickableModelMock)));

      await tester.enterText(find.byKey(Key('username')), 'username');
      await tester.enterText(find.byKey(Key('password')), 'password');
      await tester.tap(find.byKey(Key('login')));

      await tester.pump();

      verify(rebrickableModelMock.login('username', 'password', 'apiKey'));
    });

    testWidgets('Persists user token on successful login',
        (WidgetTester tester) async {
      final rebrickableModelMock = MockRebrickableModel();
      final preferencesService = MockPreferencesService();
      when(preferencesService.apiKey).thenReturn('apiKey');
      await tester.pumpWidget(MaterialApp(
          home: createApp(true,
              rebrickableModelMock: rebrickableModelMock,
              preferencesService: preferencesService)));

      await tester.enterText(find.byKey(Key('username')), 'username');
      await tester.enterText(find.byKey(Key('password')), 'password');
      await tester.tap(find.byKey(Key('login')));

      await tester.pump();

      verify(preferencesService.userToken = userToken);
    });
  });

  group('navigation test', () {
    testWidgets('Navigates to overview page when login was successful',
        (WidgetTester tester) async {
      final modelMock = MockRebrickableModel();
      final observerMock = MockNavigatorObserver();
      when(modelMock.login('username', 'password', 'apiKey'))
          .thenAnswer((_) async => userToken);
      await tester.pumpWidget(MaterialApp(
          home: createApp(true,
              rebrickableModelMock: modelMock,
              navigatorObserverMock: observerMock)));

      await tester.enterText(find.byKey(Key('username')), 'username');
      await tester.enterText(find.byKey(Key('password')), 'password');
      await tester.tap(find.byKey(Key('login')));

      await tester.pump();

      fail('fix line below');
      //verify(observerMock.didPush(captureAny, any)).called(2);
    });
  });

  testWidgets('Does not navigate to overview page when login was unsuccessful',
      (WidgetTester tester) async {
    final modelMock = MockRebrickableModel();
    final observerMock = MockNavigatorObserver();
    await tester.pumpWidget(MaterialApp(
        home: createApp(false,
            rebrickableModelMock: modelMock,
            navigatorObserverMock: observerMock)));

    await tester.enterText(find.byKey(Key('username')), 'username');
    await tester.enterText(find.byKey(Key('password')), 'password');
    await tester.tap(find.byKey(Key('login')));

    await tester.pump();

    fail('fix line below');
    //verify(observerMock.didPush(captureAny, any)).called(1);
  });
}
