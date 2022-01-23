import 'package:brick_app/model/set_or_moc.dart';
import 'package:brick_app/widgets/parts_button.dart';
import 'package:brick_app/widgets/sets_grid_tile.dart';
import 'package:flutter/material.dart';

import 'delete_from_list_button.dart';
import 'mocs_button.dart';

typedef OnTapCallback = void Function(dynamic);

class SetsGridView extends StatelessWidget {
  final List<SetOrMoc> sets;
  final int? setListId;
  final Function? onSetDeleted;

  const SetsGridView(this.sets, {this.setListId, this.onSetDeleted, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: sets.isNotEmpty
            ? ListView.builder(
                itemCount: sets.length,
                itemBuilder: (context, index) => SetsGridTile(
                  sets[index],
                  buttons: [
                    MocsButton(sets[index]),
                    PartsButton(sets[index]),
                    setListId != null
                        ? DeleteFromListButton(sets[index],
                            setListId: setListId!, onSetDeleted: onSetDeleted)
                        : Container()
                  ],
                ),
              )
            : const Text('Nothing to see here'),
      );
}
