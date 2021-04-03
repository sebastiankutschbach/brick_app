import 'package:brick_app/model/set_or_moc.dart';

class BrickSet extends SetOrMoc {
  final String setNum;
  final String name;
  final int year;
  final int themeId;
  final int numParts;
  final String imgUrl;
  final String url;
  final DateTime lastModified;

  BrickSet.fromJson(Map<String, dynamic> json)
      : setNum = json['set_num'],
        name = json['name'],
        year = json['year'],
        themeId = json['theme_id'],
        numParts = json['num_parts'],
        imgUrl = json['set_img_url'],
        url = json['set_url'],
        lastModified = DateTime.parse(json['last_modified_dt']);
}
