import 'package:brick_app/model/set_or_moc.dart';
import 'package:brick_app/widgets/parts_button.dart';
import 'package:brick_app/widgets/set_home_button.dart';
import 'package:brick_app/widgets/sets_grid_tile.dart';
import 'package:flutter/material.dart';

import 'mocs_button.dart';

typedef OnTapCallback = void Function(dynamic);

class SetsGridView extends StatelessWidget {
  final List<SetOrMoc> sets;

  const SetsGridView(this.sets, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            ListView.builder(
              itemCount: sets.length,
              itemBuilder: (context, index) => SetsGridTile(
                sets[index],
                buttons: [
                  SetHomeButton(sets[index]),
                  MocsButton(sets[index]),
                  PartsButton(sets[index])
                ],
              ),
            ),
          ],
        ),
      );
}
