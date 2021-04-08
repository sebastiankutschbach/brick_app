import 'package:brick_app/model/inventory.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  group('from json', () {
    test('valid', () {
      final inventory = Inventory.fromJson(inventoryJson);

      expect(inventory.id, 173266);
      expect(inventory.partId, 173266);
      expect(inventory.setNum, "8063-1");
      expect(inventory.quantity, 3);
      expect(inventory.part, isNotNull);
      expect(inventory.color, isNotNull);
      expect(inventory.isSpare, false);
      expect(inventory.elementId, "614326");
      expect(inventory.numSets, 364);
    });
  });
}

final inventoryJson = {
  "id": 173266,
  "inv_part_id": 173266,
  "part": {
    "part_num": "3941",
    "name": "Brick Round 2 x 2 with Axle Hole",
    "part_cat_id": 20,
    "part_url":
        "https://rebrickable.com/parts/3941/brick-round-2-x-2-with-axle-hole/",
    "part_img_url":
        "https://cdn.rebrickable.com/media/parts/elements/614326.jpg",
    "external_ids": {
      "BrickOwl": ["997602"],
      "LDraw": ["3941", "6143"],
      "LEGO": ["39223", "6116", "6143"]
    },
    "print_of": null
  },
  "color": {
    "id": 0,
    "name": "Black",
    "rgb": "05131D",
    "is_trans": false,
    "external_ids": {
      "BrickLink": {
        "ext_ids": [11],
        "ext_descrs": [
          ["Black"]
        ]
      },
      "BrickOwl": {
        "ext_ids": [38],
        "ext_descrs": [
          ["Black"]
        ]
      },
      "LEGO": {
        "ext_ids": [26, 149, 1012],
        "ext_descrs": [
          ["Black", "BLACK"],
          ["Metallic Black", "MET.BLACK"],
          ["CONDUCT. BLACK"]
        ]
      },
      "Peeron": {
        "ext_ids": [null],
        "ext_descrs": [
          ["black"]
        ]
      },
      "LDraw": {
        "ext_ids": [0, 256],
        "ext_descrs": [
          ["Black"],
          ["Rubber_Black"]
        ]
      }
    }
  },
  "set_num": "8063-1",
  "quantity": 3,
  "is_spare": false,
  "element_id": "614326",
  "num_sets": 364
};
