import 'package:brick_app/model/rebrickable_model.dart';
import 'package:brick_app/presentation/widgets/delete_from_list_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

import '../mocks.dart';
import '../model/brick_set_test.dart';

main() {
  Widget _createApp(
          {RebrickableModel? rebrickableModel, Function? onSetDeleted}) =>
      MultiProvider(
        providers: [
          ChangeNotifierProvider<RebrickableModel>(
            create: (_) => rebrickableModel ?? MockRebrickableModel(),
          ),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: DeleteFromListButton(
              testBrickSet,
              setListId: 1,
              onSetDeleted: onSetDeleted ?? () {},
            ),
          ),
        ),
      );

  setUpAll(() {
    registerFallbackValue(MaterialPageRoute(builder: (_) => const Text('')));
  });

  testWidgets('renders correctly', (tester) async {
    await tester.pumpWidget(_createApp());

    expect(find.byType(Icon), findsOneWidget);
    expect(find.text('Delete'), findsOneWidget);
  });

  testWidgets('navigates to moc url', (tester) async {
    final rebrickableModel = MockRebrickableModel();
    when(() => rebrickableModel.deleteSetFromList(
        setListId: 1, setId: testBrickSet.setNum)).thenAnswer((_) async {
      return;
    });
    await tester.pumpWidget(_createApp(rebrickableModel: rebrickableModel));

    await tester.tap(find.byType(DeleteFromListButton));

    verify(() => rebrickableModel.deleteSetFromList(
        setListId: 1, setId: testBrickSet.setNum)).called(1);
  });

  testWidgets('calls onSetDeleted on press', (tester) async {
    final rebrickableModel = MockRebrickableModel();
    when(() => rebrickableModel.deleteSetFromList(
        setListId: 1, setId: testBrickSet.setNum)).thenAnswer((_) async {
      return;
    });
    bool called = false;
    await tester.pumpWidget(_createApp(
        rebrickableModel: rebrickableModel, onSetDeleted: () => called = true));

    await tester.tap(find.byType(DeleteFromListButton));

    expect(called, true);
  });
}
