import 'package:brick_app/model/set_or_moc.dart';

class Moc extends SetOrMoc {
  final String setNum;
  final String name;
  final int year;
  final int themeId;
  final int numParts;
  final String imgUrl;
  final String url;
  final String designerName;
  final String designerUrl;

  Moc.fromJson(Map<String, dynamic> json)
      : setNum = json['set_num'],
        name = json['name'],
        year = json['year'],
        themeId = json['theme_id'],
        numParts = json['num_parts'],
        imgUrl = json['moc_img_url'],
        url = json['moc_url'],
        designerName = json['designer_name'],
        designerUrl = json['designer_url'];
}
