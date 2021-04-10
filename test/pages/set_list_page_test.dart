import 'package:brick_app/model/brick_set.dart';
import 'package:brick_app/model/brick_set_list.dart';
import 'package:brick_app/model/rebrickable_model.dart';
import 'package:brick_app/pages/set_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:provider/provider.dart';

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

  NavigatorObserver navigatorObserver;

  createApp() {
    navigatorObserver = NavigatorObserverMock();
    return ChangeNotifierProvider<RebrickableModel>(
      create: (_) {
        final RebrickableModelMock mock = RebrickableModelMock();
        when(mock.getSetsFromList(listId: 521857))
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
        verify(navigatorObserver.didPush(captureAny, any))
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

        var setTileImageFinder = find.byType(Image);
        expect(setTileImageFinder, findsOneWidget);
      });
    });

    testWidgets('does navigate to set home page on tap',
        (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(createApp());

        await tester.pump();

        var setTileImageFinder = find.byIcon(Icons.menu_book);
        await tester.tap(setTileImageFinder.first);
        _verifyCorrectRouting('setRoute');
      });
    });

    testWidgets('does navigate to parts page on tap',
        (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(createApp());

        await tester.pump();

        var setTileImageFinder = find.byIcon(Icons.grain);
        await tester.tap(setTileImageFinder.first);

        _verifyCorrectRouting('partsRoute');
      });
    });

    testWidgets('does navigate to moc page on tap',
        (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(createApp());

        await tester.pump();

        var setTileImageFinder = find.byIcon(Icons.star);
        await tester.tap(setTileImageFinder.first);
        _verifyCorrectRouting('mocsRoute');
      });
    });
  });
}
