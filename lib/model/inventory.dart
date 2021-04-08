import 'package:brick_app/model/color.dart';
import 'package:brick_app/model/part.dart';

class Inventory {
  final int id;
  final int partId;
  final String setNum;
  final int quantity;
  final Part part;
  final Color color;
  final bool isSpare;
  final String elementId;
  final int numSets;

  Inventory.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        partId = json['inv_part_id'],
        setNum = json['set_num'],
        quantity = json['quantity'],
        part = Part.fromJson(json['part']),
        color = Color.fromJson(json['color']),
        isSpare = json['is_spare'] == 'true',
        elementId = json['element_id'],
        numSets = json['num_sets'];
}
