import 'package:brick_app/model/set_or_moc.dart';
import 'package:brick_app/presentation/widgets/mocs_button.dart';
import 'package:brick_app/presentation/widgets/parts_button.dart';
import 'package:brick_app/presentation/widgets/sets_grid_tile.dart';
import 'package:brick_app/presentation/widgets/sets_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../model/brick_set_test.dart';

main() {
  Widget _createApp({List<SetOrMoc>? sets}) => MaterialApp(
        home: Scaffold(
          body: SetsGridView(sets ?? [testBrickSet]),
        ),
      );

  testWidgets('renders tile for every set', (tester) async {
    await tester.pumpWidget(_createApp(sets: [testBrickSet, testBrickSet]));

    expect(find.byType(SetsGridTile), findsNWidgets(2));
  });

  testWidgets('renders moc button', (tester) async {
    await tester.pumpWidget(_createApp());

    expect(
        find.descendant(
            of: find.byType(SetsGridTile), matching: find.byType(MocsButton)),
        findsOneWidget);
  });

  testWidgets('renders parts button', (tester) async {
    await tester.pumpWidget(_createApp());

    expect(
        find.descendant(
            of: find.byType(SetsGridTile), matching: find.byType(PartsButton)),
        findsOneWidget);
  });

  testWidgets('renders delete button if set list id is set', (tester) async {
    await tester.pumpWidget(_createApp());

    expect(
        find.descendant(
            of: find.byType(SetsGridTile), matching: find.byType(PartsButton)),
        findsOneWidget);
  });
}
