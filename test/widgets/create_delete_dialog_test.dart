import 'package:brick_app/presentation/widgets/create_delete_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks.dart';

main() {
  Widget _createApp(
          {NavigatorObserver? navigatorObserver,
          AsyncCallback? onOkButtonPress}) =>
      MaterialApp(
        home: Scaffold(
          body: CreateDeleteDialog(
              title: 'title',
              content: const Text('content'),
              okButtonText: 'okButtonText',
              onOkButtonPress: onOkButtonPress),
        ),
        navigatorObservers: [navigatorObserver ?? MockNavigatorObserver()],
      );

  setUpAll(() {
    registerFallbackValue(MaterialPageRoute(builder: (_) => const Text('')));
  });

  testWidgets('renders title correctly', (tester) async {
    await tester.pumpWidget(_createApp());

    expect(find.text('title'), findsOneWidget);
  });

  testWidgets('renders buttons correctly', (tester) async {
    await tester.pumpWidget(_createApp());

    final elevatedButtonFinder = find.byType(ElevatedButton);
    expect(elevatedButtonFinder, findsNWidgets(2));

    expect(
        find.descendant(
            of: elevatedButtonFinder.first, matching: find.text('Cancel')),
        findsOneWidget);

    expect(
        find.descendant(
            of: elevatedButtonFinder.last, matching: find.text('okButtonText')),
        findsOneWidget);
  });

  testWidgets('calls callback on ok button press', (tester) async {
    bool called = false;
    Future<void> callback() async => called = true;
    await tester.pumpWidget(_createApp(onOkButtonPress: callback));

    final elevatedButtonFinder = find.byType(ElevatedButton);

    await tester.tap(elevatedButtonFinder.last);

    expect(called, true);
  });

  testWidgets('closes dialog on cancel', (tester) async {
    final navigatorObserver = MockNavigatorObserver();
    await tester.pumpWidget(_createApp(navigatorObserver: navigatorObserver));

    final elevatedButtonFinder = find.byType(ElevatedButton);

    await tester.tap(elevatedButtonFinder.first);

    verify(() => navigatorObserver.didPop(any(), any())).called(1);
  });
}
