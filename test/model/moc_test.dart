import 'package:brick_app/model/moc.dart';
import 'package:flutter_test/flutter_test.dart';

final Moc testMoc = Moc.fromJson(
  {
    "set_num": "MOC-56901",
    "name": "cole's desert car",
    "year": 2020,
    "theme_id": 435,
    "num_parts": 165,
    "moc_img_url": "https://cdn.rebrickable.com/media/mocs/moc-56901.jpg",
    "moc_url":
        "https://rebrickable.com/mocs/MOC-56901/trainsrkool176/coles-desert-car/",
    "designer_name": "trainsrkool176",
    "designer_url": "https://rebrickable.com/users/trainsrkool176/mocs/"
  },
);

main() {
  group('from Json', () {
    test('valid json', () {
      expect(testMoc.setNum, "MOC-56901");
      expect(testMoc.name, "cole's desert car");
      expect(testMoc.year, 2020);
      expect(testMoc.themeId, 435);
      expect(testMoc.numParts, 165);
      expect(testMoc.imgUrl,
          "https://cdn.rebrickable.com/media/mocs/moc-56901.jpg");
      expect(testMoc.url,
          "https://rebrickable.com/mocs/MOC-56901/trainsrkool176/coles-desert-car/");
      expect(testMoc.designerName, "trainsrkool176");
      expect(testMoc.designerUrl,
          "https://rebrickable.com/users/trainsrkool176/mocs/");
    });
  });
}
