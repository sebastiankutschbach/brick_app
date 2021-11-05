import 'package:brick_app/model/rebrickable_model.dart';
import 'package:brick_app/model/set_or_moc.dart';
import 'package:brick_app/pages/utils.dart';
import 'package:brick_app/widgets/tile_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeleteFromListButton extends StatelessWidget {
  final SetOrMoc set;
  final int setListId;

  const DeleteFromListButton(this.set, {required this.setListId, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) => TileButton(
        key: Key('delete_from_list_button_${set.setNum}'),
        iconData: Icons.delete_forever,
        style: ElevatedButton.styleFrom(primary: Colors.red),
        label: 'Delete',
        onPressedCallback: () async {
          await context
              .read<RebrickableModel>()
              .deleteSetFromList(setListId: setListId, setId: set.setNum);
          showSnackBar(context, 'Set deleted successfully');
        },
      );
}
