import 'package:brick_app/model/brick_set.dart';
import 'package:flutter_test/flutter_test.dart';

final BrickSet testBrickSet = BrickSet.fromJson({
  "set_num": "70672-1",
  "name": "Cole's Dirt Bike",
  "year": 2019,
  "theme_id": 435,
  "num_parts": 221,
  "set_img_url": "https://cdn.rebrickable.com/media/sets/70672-1/12578.jpg",
  "set_url": "https://rebrickable.com/sets/70672-1/coles-dirt-bike/",
  "last_modified_dt": "2019-04-19T17:19:54.565420Z"
});

main() {
  group('from Json', () {
    test('valid json', () {
      expect(testBrickSet.setNum, "70672-1");
      expect(testBrickSet.name, "Cole's Dirt Bike");
      expect(testBrickSet.year, 2019);
      expect(testBrickSet.themeId, 435);
      expect(testBrickSet.numParts, 221);
      expect(testBrickSet.imgUrl,
          "https://cdn.rebrickable.com/media/sets/70672-1/12578.jpg");
      expect(testBrickSet.url,
          "https://rebrickable.com/sets/70672-1/coles-dirt-bike/");
      expect(testBrickSet.lastModified.toIso8601String(),
          "2019-04-19T17:19:54.565420Z");
    });
  });
}
