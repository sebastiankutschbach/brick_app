import 'package:brick_app/model/color.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  group('from json', () {
    test('valid', () {
      final color = Color.fromJson(colorJson);

      expect(color.id, 0);
      expect(color.name, "Black");
      expect(color.rgb, "05131D");
      expect(color.isTransparent, false);
    });
  });
}

final colorJson = {
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
};
