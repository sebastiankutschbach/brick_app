import 'package:brick_app/model/rebrickable_model.dart';
import 'package:brick_app/pages/moc_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

import '../mocks.dart';
import '../model/brick_set_test.dart';
import '../model/moc_test.dart';

main() {
  _createApp() => ChangeNotifierProvider<RebrickableModel>(
        create: (_) {
          final mock = MockRebrickableModel();
          when(() => mock.getMocsFromSet(setNum: any(named: 'setNum')))
              .thenAnswer(
            (_) async => [testMoc],
          );
          return mock;
        },
        child: MaterialApp(
          home: MocPage(testBrickSet),
        ),
      );

  testWidgets('renders circular progress indicator while loading',
      (tester) async {
    await tester.pumpWidget(_createApp());

    expect(find.text(testBrickSet.name), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('renders set grid view after loading', (tester) async {
    await tester.pumpWidget(_createApp());

    await tester.pump();

    expect(find.text(testBrickSet.name), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
  });
}
