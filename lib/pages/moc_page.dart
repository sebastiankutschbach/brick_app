import 'dart:developer';

import 'package:brick_app/model/brick_set.dart';
import 'package:brick_app/model/rebrickable_model.dart';
import 'package:brick_app/widgets/brick_app_bar.dart';
import 'package:brick_app/widgets/sets_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MocPage extends StatelessWidget {
  final BrickSet brickSet;

  MocPage(this.brickSet);

  Widget build(BuildContext context) {
    final service = context.read<RebrickableModel>();
    return Scaffold(
      appBar: BrickAppBar(
        Text(brickSet.name),
      ),
      body: FutureBuilder(
        future: service.getMocsFromSet(setNum: brickSet.setNum),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SetsGridView(
              snapshot.data,
              withButtons: false,
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
