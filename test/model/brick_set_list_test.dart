import 'package:brick_app/model/brick_set_list.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  group('fromJson', () {
    test('should create brick set from valid json', () {
      final brickSetList = BrickSetList.fromJson({
        "id": 521857,
        "is_buildable": true,
        "name": "Set List",
        "num_sets": 23
      });

      expect(brickSetList.id, 521857);
      expect(brickSetList.isBuildable, isTrue);
      expect(brickSetList.name, "Set List");
      expect(brickSetList.numSets, 23);
    });
  });
}
