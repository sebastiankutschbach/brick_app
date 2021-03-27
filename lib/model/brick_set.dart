class BrickSet {
  final String setNum;
  final String name;
  final int year;
  final int themeId;
  final int numParts;
  final String setImgUrl;
  final String setUrl;
  final DateTime lastModified;

  BrickSet.fromJson(Map<String, dynamic> json)
      : setNum = json['set_num'],
        name = json['name'],
        year = json['year'],
        themeId = json['theme_id'],
        numParts = json['num_parts'],
        setImgUrl = json['set_img_url'],
        setUrl = json['set_url'],
        lastModified = DateTime.parse(json['last_modified_dt']);
}
