import 'package:brick_app/model/part.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  group('from json', () {
    test('valid', () {
      final part = Part.fromJson({
        "part_num": "2431pr0028",
        "name": "Tile 1 x 4 with Train Controls Print",
        "part_cat_id": 19,
        "part_url":
            "https://rebrickable.com/parts/2431pr0028/tile-1-x-4-with-train-controls-print/",
        "part_img_url":
            "https://cdn.rebrickable.com/media/parts/elements/4215740.jpg",
        "external_ids": {
          "BrickLink": ["2431px17"],
          "BrickOwl": ["572650"],
          "LDraw": ["2431pc0"],
          "LEGO": ["48196"],
          "Peeron": ["2431pc0"]
        },
        "print_of": "2431"
      });

      expect(part.partNum, "2431pr0028");
      expect(part.name, "Tile 1 x 4 with Train Controls Print");
      expect(part.partCatId, 19);
      expect(part.partUrl,
          "https://rebrickable.com/parts/2431pr0028/tile-1-x-4-with-train-controls-print/");
      expect(part.partImgUrl,
          "https://cdn.rebrickable.com/media/parts/elements/4215740.jpg");
      expect(part.printOf, "2431");
    });
  });
}
