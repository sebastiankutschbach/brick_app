import 'package:brick_app/model/brick_set.dart';
import 'package:brick_app/pages/set_view_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
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

  createApp() => MaterialApp(
        home: SetViewPage(
          brickSet,
        ),
      );

  group('app bar', () {
    testWidgets('does show the name of the set in the app bar', (tester) async {
      await tester.pumpWidget(createApp());

      final appBarFinder = find.byType(AppBar);

      final textInAppBar = find
          .descendant(of: appBarFinder, matching: find.byType(Text))
          .evaluate()
          .single
          .widget as Text;

      expect(textInAppBar.data, startsWith("Cole's Dirt Bike"));
    });
  });
}
