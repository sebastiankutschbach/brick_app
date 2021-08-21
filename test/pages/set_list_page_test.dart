import 'package:brick_app/model/brick_set.dart';
import 'package:brick_app/model/brick_set_list.dart';
import 'package:brick_app/model/rebrickable_model.dart';
import 'package:brick_app/pages/set_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:provider/provider.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks.dart';

main() {
  final brickSetList = BrickSetList.fromJson(
      {"id": 521857, "is_buildable": true, "name": "Set List", "num_sets": 1});
  final brickSet = BrickSet.fromJson({
    "set_num": "70672-1",
    "name": "Cole's Dirt Bike",
    "year": 2019,
    "theme_id": 435,
    "num_parts": 221,
    "set_img_url": "https://cdn.rebrickable.com/media/sets/70672-1/12578.jpg",
    "set_url": "https://rebrickable.com/sets/70672-1/coles-dirt-bike/",
    "last_modified_dt": "2019-04-19T17:19:54.565420Z"
  });

  late NavigatorObserver navigatorObserver;

  setUpAll(() {
    registerFallbackValue(MaterialPageRoute(builder: (_) => Text('')));
  });

  void _increaseScreenSizeForTest(WidgetTester tester) {
    tester.binding.window.physicalSizeTestValue = Size(1920, 1080);
    // resets the screen to its original size after the test end
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
  }

  createApp() {
    navigatorObserver = MockNavigatorObserver();
    return ChangeNotifierProvider<RebrickableModel>(
      create: (_) {
        final RebrickableModel mock = MockRebrickableModel();
        when(() => mock.getSetsFromList(listId: 521857))
            .thenAnswer((_) async => [brickSet]);
        return mock;
      },
      child: MaterialApp(
        home: SetListPage(
          brickSetList: brickSetList,
        ),
        navigatorObservers: [navigatorObserver],
      ),
    );
  }

  void _verifyCorrectRouting(String routeName) {
    List<MaterialPageRoute> pushedRoutes =
        verify(() => navigatorObserver.didPush(captureAny(), any()))
            .captured
            .cast<MaterialPageRoute>();
    expect(
        pushedRoutes
            .where((element) => element.settings.name == routeName)
            .length,
        1);
  }

  group('app bar', () {
    testWidgets('does show the name of the set list in the app bar',
        (tester) async {
      await tester.pumpWidget(createApp());

      final appBarFinder = find.byType(AppBar);

      final textInAppBar = find
          .descendant(of: appBarFinder, matching: find.byType(Text))
          .evaluate()
          .single
          .widget as Text;

      expect(textInAppBar.data, startsWith('Set List'));
    });
  });

  group('sets view', () {
    testWidgets('does show a tile for each set', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(createApp());

        await tester.pumpAndSettle();

        final setTileFinder = find.byKey(Key('tile_70672-1'));
        expect(setTileFinder, findsOneWidget);
      });
    });

    testWidgets('does show buttons after first tap',
            (WidgetTester tester) async {
          await mockNetworkImagesFor(() async {
            _increaseScreenSizeForTest(tester);
            await tester.pumpWidget(createApp());

            await tester.pumpAndSettle();

            expect(find.byKey(Key('home_button_70672-1')), findsNothing);
            expect(find.byKey(Key('mocs_button_70672-1')), findsNothing);
            expect(find.byKey(Key('parts_button_70672-1')), findsNothing);

            final setTileFinder = find.byKey(Key('tile_70672-1'));
            await tester.tap(setTileFinder.first);

            await tester.pump();

            expect(find.byKey(Key('home_button_70672-1')), findsOneWidget);
            expect(find.byKey(Key('mocs_button_70672-1')), findsOneWidget);
            expect(find.byKey(Key('parts_button_70672-1')), findsOneWidget);
          });
        });

    testWidgets('does navigate to set home page on tap',
        (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        _increaseScreenSizeForTest(tester);
        await tester.pumpWidget(createApp());

        await tester.pumpAndSettle();

        final setTileFinder = find.byKey(Key('tile_70672-1'));
        await tester.tap(setTileFinder.first);

        await tester.pump();

        final buttonFinder =  find.byKey(Key('home_button_70672-1'));
        await tester.tap(buttonFinder.first);

        _verifyCorrectRouting('setRoute');
      });
    });

    testWidgets('does navigate to parts page on tap',
        (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        _increaseScreenSizeForTest(tester);
        await tester.pumpWidget(createApp());

        await tester.pumpAndSettle();

        final setTileFinder = find.byKey(Key('tile_70672-1'));
        await tester.tap(setTileFinder.first);

        await tester.pump();

        final buttonFinder =  find.byKey(Key('parts_button_70672-1'));
        await tester.tap(buttonFinder.first);

        _verifyCorrectRouting('partsRoute');
      });
    });

    testWidgets('does navigate to moc page on tap',
        (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        _increaseScreenSizeForTest(tester);
        await tester.pumpWidget(createApp());

        await tester.pumpAndSettle();

        final setTileFinder = find.byKey(Key('tile_70672-1'));
        await tester.tap(setTileFinder.first);

        await tester.pumpAndSettle();

        final buttonFinder =  find.byKey(Key('mocs_button_70672-1'));
        await tester.tap(buttonFinder.first);

        _verifyCorrectRouting('mocsRoute');
      });
    });
  });
}
