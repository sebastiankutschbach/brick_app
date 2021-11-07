import 'package:brick_app/model/rebrickable_model.dart';
import 'package:brick_app/pages/login_page.dart';
import 'package:brick_app/service/preferences_service.dart';
import 'package:brick_app/widgets/brick_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

import '../mocks.dart';

const userToken = 'myUserToken';

void main() {
  createApp(bool loginSuccess,
          {MockRebrickableModel? rebrickableModelMock,
          MockNavigatorObserver? navigatorObserverMock,
          PreferencesService? preferencesService}) =>
      MultiProvider(
        providers: [
          ChangeNotifierProvider<RebrickableModel>(create: (_) {
            final modelMock = rebrickableModelMock ?? MockRebrickableModel();
            when(() => modelMock.login('username', 'password', 'apiKey'))
                .thenAnswer((_) async => loginSuccess ? userToken : '');
            when(() => modelMock.loginWithToken('userToken', 'apiKey'))
                .thenAnswer((_) async => loginSuccess ? userToken : '');
            return modelMock;
          }),
          ChangeNotifierProvider<PreferencesService>(create: (_) {
            final service = MockPreferencesService();
            when(() => service.apiKey).thenReturn('apiKey');
            when(() => service.userToken).thenReturn('');
            return preferencesService ?? service;
          }),
        ],
        child: MaterialApp(
          home: const LoginPage(),
          navigatorObservers:
              navigatorObserverMock != null ? [navigatorObserverMock] : [],
        ),
      );

  setUpAll(() {
    registerFallbackValue(MaterialPageRoute(builder: (_) => const Text('')));
  });

  group('smoke test', () {
    testWidgets(
        'Finds title, login button, username and password fields on login page',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: createApp(true)));

      expect(find.byType(BrickAppBar), findsOneWidget);
      expect(find.text('Rebrickable Login'), findsOneWidget);

      expect(find.byKey(const Key('username')), findsOneWidget);
      expect(find.byKey(const Key('password')), findsOneWidget);

      expect(find.byKey(const Key('login')), findsOneWidget);
    });
  });

  group('input test', () {
    testWidgets('Does not accept empty username', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: createApp(true)));

      expect(find.byKey(const Key('username')), findsOneWidget);
      await tester.tap(find.text('Login'));

      await tester.pumpAndSettle();

      expect(find.text('Username cannot be empty'), findsOneWidget);
    });

    testWidgets('Does not accept empty password', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: createApp(true)));

      await tester.enterText(find.byKey(const Key('username')), 'myUsername');
      await tester.tap(find.byKey(const Key('login')));

      await tester.pumpAndSettle();

      expect(find.text('Password cannot be empty'), findsOneWidget);
    });
  });

  group('login test', () {
    testWidgets('Tries to login when username and password given',
        (WidgetTester tester) async {
      final rebrickableModelMock = MockRebrickableModel();
      when(() => rebrickableModelMock.getUsersSetLists())
          .thenAnswer((_) async => []);
      await tester.pumpWidget(MaterialApp(
          home: createApp(true, rebrickableModelMock: rebrickableModelMock)));

      await tester.enterText(find.byKey(const Key('username')), 'username');
      await tester.enterText(find.byKey(const Key('password')), 'password');
      await tester.tap(find.byKey(const Key('login')));

      await tester.pump();

      verify(
          () => rebrickableModelMock.login('username', 'password', 'apiKey'));
    });

    testWidgets('Persists user token on successful login',
        (WidgetTester tester) async {
      final rebrickableModelMock = MockRebrickableModel();
      when(() => rebrickableModelMock.getUsersSetLists())
          .thenAnswer((_) async => []);
      final preferencesService = MockPreferencesService();
      when(() => preferencesService.apiKey).thenReturn('apiKey');
      when(() => preferencesService.userToken).thenReturn('');
      when(() => preferencesService.userToken = userToken)
          .thenReturn('userToken');
      await tester.pumpWidget(MaterialApp(
          home: createApp(true,
              rebrickableModelMock: rebrickableModelMock,
              preferencesService: preferencesService)));

      await tester.enterText(find.byKey(const Key('username')), 'username');
      await tester.enterText(find.byKey(const Key('password')), 'password');
      await tester.tap(find.byKey(const Key('login')));

      await tester.pump();

      verify(() => preferencesService.userToken = userToken);
    });
  });

  group('navigation test', () {
    testWidgets('Navigates to overview page when login was successful',
        (WidgetTester tester) async {
      final modelMock = MockRebrickableModel();
      when(() => modelMock.getUsersSetLists()).thenAnswer((_) async => []);
      final observerMock = MockNavigatorObserver();
      when(() => modelMock.login('username', 'password', 'apiKey'))
          .thenAnswer((_) async => userToken);
      await tester.pumpWidget(MaterialApp(
          home: createApp(true,
              rebrickableModelMock: modelMock,
              navigatorObserverMock: observerMock)));

      await tester.enterText(find.byKey(const Key('username')), 'username');
      await tester.enterText(find.byKey(const Key('password')), 'password');
      await tester.tap(find.byKey(const Key('login')));

      await tester.pump();

      verify(() => observerMock.didPush(captureAny(), any())).called(2);
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

    await tester.enterText(find.byKey(const Key('username')), 'username');
    await tester.enterText(find.byKey(const Key('password')), 'password');
    await tester.tap(find.byKey(const Key('login')));

    await tester.pump();

    verify(() => observerMock.didPush(captureAny(), any())).called(1);
  });
}
