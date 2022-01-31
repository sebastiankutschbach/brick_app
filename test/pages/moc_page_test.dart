import 'package:bloc_test/bloc_test.dart';
import 'package:brick_app/application/cubit/moc_page_cubit.dart';
import 'package:brick_app/core/failure.dart';
import 'package:brick_app/injection.dart';
import 'package:brick_app/pages/moc_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mocks.dart';
import '../model/brick_set_test.dart';
import '../model/moc_test.dart';

main() {
  _createTestableWidget({MocPageState? initialState}) {
    getIt.allowReassignment = true;
    final cubit = MockMocPageCubit();
    whenListen(cubit, const Stream<MocPageState>.empty(),
        initialState: initialState ?? MocPageLoading());
    getIt.registerFactoryParam<MocPageCubit, String, void>((_, __) => cubit);

    return MaterialApp(
      home: MocPage(testBrickSet),
    );
  }

  testWidgets('shows loading state', (WidgetTester tester) async {
    await tester.pumpWidget(_createTestableWidget());

    expect(find.byKey(const Key('loading')), findsOneWidget);
  });

  testWidgets('shows error state', (WidgetTester tester) async {
    await tester.pumpWidget(
      _createTestableWidget(
        initialState: const MocPageError(
          Failure(''),
        ),
      ),
    );

    expect(find.byKey(const Key('error')), findsOneWidget);
  });

  testWidgets('shows success state', (WidgetTester tester) async {
    await tester.pumpWidget(
      _createTestableWidget(
        initialState: MocPageLoaded([testMoc]),
      ),
    );

    expect(find.byKey(const Key('success')), findsOneWidget);
  });
}
