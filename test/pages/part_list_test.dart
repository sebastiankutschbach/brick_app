import 'package:brick_app/model/brick_set.dart';
import 'package:brick_app/pages/part_list.dart';
import 'package:brick_app/widgets/brick_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  group('smoke test', () {
    testWidgets('renders correcty', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: PartList(brickSet),
      ));

      expect(
          find.descendant(
              of: find.byType(BrickAppBar),
              matching: find.text('Parts of Set: ${brickSet.name}')),
          findsOneWidget);
    });
  });
}

final BrickSet brickSet = BrickSet.fromJson({
  "set_num": "70672-1",
  "name": "Cole's Dirt Bike",
  "year": 2019,
  "theme_id": 435,
  "num_parts": 221,
  "set_img_url": "https://cdn.rebrickable.com/media/sets/70672-1/12578.jpg",
  "set_url": "https://rebrickable.com/sets/70672-1/coles-dirt-bike/",
  "last_modified_dt": "2019-04-19T17:19:54.565420Z"
});
