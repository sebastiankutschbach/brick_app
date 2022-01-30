import 'package:bloc_test/bloc_test.dart';
import 'package:brick_app/application/cubit/pdf_page_cubit.dart';
import 'package:brick_app/core/failure.dart';
import 'package:brick_app/injection.dart';
import 'package:brick_app/pages/pdf_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mocks.dart';

main() {
  const String setNum = "setNum";
  const String mocNum = "mocNum";

  Widget _createTestableWidget({PdfPageState? initialState}) {
    final cubit = MockPdfPageCubit();
    whenListen(cubit, const Stream<PdfPageState>.empty(),
        initialState: initialState ?? PdfPageLoading());
    getIt.allowReassignment = true;
    getIt.registerFactoryParam<PdfPageCubit, String, String>((_, __) => cubit);

    return const MaterialApp(
        home: PdfPage(
      setNum: setNum,
      mocNum: mocNum,
    ));
  }

  testWidgets('shows loading state', (WidgetTester tester) async {
    await tester.pumpWidget(_createTestableWidget());

    expect(find.byKey(const Key('loading')), findsOneWidget);
  });

  testWidgets('shows error state', (WidgetTester tester) async {
    await tester.pumpWidget(
      _createTestableWidget(
        initialState: const PdfPageError(
          Failure(''),
        ),
      ),
    );

    expect(find.byKey(const Key('error')), findsOneWidget);
  });

  testWidgets('shows success state', (WidgetTester tester) async {
    await tester.pumpWidget(
      _createTestableWidget(
        initialState: PdfPageLoaded(MockPdfDocument()),
      ),
    );

    expect(find.byKey(const Key('success')), findsOneWidget);
  });
}
