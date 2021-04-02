import 'package:brick_app/model/moc.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  group('from Json', () {
    test('valid json', () {
      final moc = Moc.fromJson(
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

      expect(moc.setNum, "MOC-56901");
      expect(moc.name, "cole's desert car");
      expect(moc.year, 2020);
      expect(moc.themeId, 435);
      expect(moc.numParts, 165);
      expect(
          moc.imgUrl, "https://cdn.rebrickable.com/media/mocs/moc-56901.jpg");
      expect(moc.url,
          "https://rebrickable.com/mocs/MOC-56901/trainsrkool176/coles-desert-car/");
      expect(moc.designerName, "trainsrkool176");
      expect(moc.designerUrl,
          "https://rebrickable.com/users/trainsrkool176/mocs/");
    });
  });
}
