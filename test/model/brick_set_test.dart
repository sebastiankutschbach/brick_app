import 'package:brick_app/model/brick_set.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  group('from Json', () {
    test('valid json', () {
      final brickSet = BrickSet.fromJson({
        "set_num": "70672-1",
        "name": "Cole's Dirt Bike",
        "year": 2019,
        "theme_id": 435,
        "num_parts": 221,
        "set_img_url":
            "https://cdn.rebrickable.com/media/sets/70672-1/12578.jpg",
        "set_url": "https://rebrickable.com/sets/70672-1/coles-dirt-bike/",
        "last_modified_dt": "2019-04-19T17:19:54.565420Z"
      });

      expect(brickSet.setNum, "70672-1");
      expect(brickSet.name, "Cole's Dirt Bike");
      expect(brickSet.year, 2019);
      expect(brickSet.themeId, 435);
      expect(brickSet.numParts, 221);
      expect(brickSet.setImgUrl,
          "https://cdn.rebrickable.com/media/sets/70672-1/12578.jpg");
      expect(brickSet.setUrl,
          "https://rebrickable.com/sets/70672-1/coles-dirt-bike/");
      expect(brickSet.lastModified.toIso8601String(),
          "2019-04-19T17:19:54.565420Z");
    });
  });
}
