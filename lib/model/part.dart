class Part {
  final String partNum;
  final String name;
  final int partCatId;
  final String partUrl;
  final String partImgUrl;
  final String printOf;

  Part.fromJson(Map<String, dynamic> json)
      : partNum = json['part_num'],
        name = json['name'],
        partCatId = json['part_cat_id'],
        partUrl = json['part_url'],
        partImgUrl = json['part_img_url'],
        printOf = json['print_of'];
}
