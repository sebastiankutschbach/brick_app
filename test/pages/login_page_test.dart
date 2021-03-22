import 'package:brick_app/model/rebrickable_model.dart';
import 'package:brick_app/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

class RebrickableModelMock extends Mock implements RebrickableModel {}

class NavigatorObserverMock extends Mock implements NavigatorObserver {}

void main() {
  final app = MaterialApp(
    home: ChangeNotifierProvider<RebrickableModel>(
      create: (context) => RebrickableModelMock(),
      child: LoginPage(),
    ),
  );
  group('smoke test', () {
    testWidgets(
        'Finds title, login button, username and password fields on login page',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: app));

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Rebrickable Login'), findsOneWidget);

      expect(find.byKey(Key('username')), findsOneWidget);
      expect(find.byKey(Key('password')), findsOneWidget);

      expect(find.byKey(Key('login')), findsOneWidget);
    });
  });

  group('input test', () {
    testWidgets('Does not accept empty username', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: app));

      expect(find.byKey(Key('username')), findsOneWidget);
      await tester.tap(find.text('Login'));

      await tester.pumpAndSettle();

      expect(find.text('Username cannot be empty'), findsOneWidget);
    });

    testWidgets('Does not accept empty password', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: app));

      await tester.enterText(find.byKey(Key('username')), 'myUsername');
      await tester.tap(find.byKey(Key('login')));

      await tester.pumpAndSettle();

      expect(find.text('Password cannot be empty'), findsOneWidget);
    });
  });

  group('login test', () {
    testWidgets('Tries to login when username and password given',
        (WidgetTester tester) async {
      final modelMock = RebrickableModelMock();
      when(modelMock.login('username', 'password'))
          .thenAnswer((_) async => true);
      final app = MaterialApp(
        home: ChangeNotifierProvider<RebrickableModel>(
          create: (context) => modelMock,
          child: LoginPage(),
        ),
      );
      await tester.pumpWidget(MaterialApp(home: app));

      await tester.enterText(find.byKey(Key('username')), 'username');
      await tester.enterText(find.byKey(Key('password')), 'password');
      await tester.tap(find.byKey(Key('login')));

      await tester.pumpAndSettle();

      verify(modelMock.login('username', 'password'));
    });

    group('navigation test', () {
      testWidgets('Navigates to overview page when login was successful',
          (WidgetTester tester) async {
        final modelMock = RebrickableModelMock();
        final observerMock = NavigatorObserverMock();
        when(modelMock.login('username', 'password'))
            .thenAnswer((_) async => true);
        final app = MaterialApp(
          home: ChangeNotifierProvider<RebrickableModel>(
            create: (context) => modelMock,
            child: LoginPage(),
          ),
          navigatorObservers: [observerMock],
        );
        await tester.pumpWidget(MaterialApp(home: app));

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
      when(modelMock.login('username', 'password'))
          .thenAnswer((_) async => false);
      final app = MaterialApp(
        home: ChangeNotifierProvider<RebrickableModel>(
          create: (context) => modelMock,
          child: LoginPage(),
        ),
        navigatorObservers: [observerMock],
      );
      await tester.pumpWidget(MaterialApp(home: app));

      await tester.enterText(find.byKey(Key('username')), 'username');
      await tester.enterText(find.byKey(Key('password')), 'password');
      await tester.tap(find.byKey(Key('login')));

      await tester.pumpAndSettle();

      verify(observerMock.didPush(captureAny, any)).called(1);
    });
  });
}
