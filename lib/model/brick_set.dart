class BrickSet {
  final int id;
  final bool isBuildable;
  final String name;
  final int numSets;

  BrickSet.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        isBuildable = json['is_buildable'],
        name = json['name'],
        numSets = json['num_sets'];
}
