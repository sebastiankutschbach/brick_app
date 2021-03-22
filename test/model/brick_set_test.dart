import 'package:brick_app/model/brick_set.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  group('fromJson', () {
    test('should create brick set from valid json', () {
      final brickSet = BrickSet.fromJson({
        "id": 521857,
        "is_buildable": true,
        "name": "Set List",
        "num_sets": 23
      });

      expect(brickSet.id, 521857);
      expect(brickSet.isBuildable, isTrue);
      expect(brickSet.name, "Set List");
      expect(brickSet.numSets, 23);
    });
  });
}
