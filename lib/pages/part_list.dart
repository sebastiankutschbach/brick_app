import 'package:brick_app/model/brick_set.dart';
import 'package:brick_app/widgets/brick_app_bar.dart';
import 'package:flutter/material.dart';

class PartList extends StatelessWidget {
  final BrickSet brickSet;

  PartList(this.brickSet);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BrickAppBar(Text('Parts of Set: ${brickSet.name}')),
      body: Center(
        child: Text('not implemented yet'),
      ),
    );
  }
}
