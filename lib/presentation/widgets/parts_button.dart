import 'package:brick_app/model/set_or_moc.dart';
import 'package:brick_app/presentation/pages/part_list.dart';
import 'package:brick_app/presentation/widgets/tile_button.dart';
import 'package:flutter/material.dart';

class PartsButton extends StatelessWidget {
  final SetOrMoc set;

  const PartsButton(this.set, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => TileButton(
        key: Key('parts_button_${set.setNum}'),
        iconData: Icons.grain,
        label: 'Parts',
        onPressedCallback: () => Navigator.of(context).push(
          MaterialPageRoute(
            settings: const RouteSettings(name: 'partsRoute'),
            builder: (context) => PartList(set),
          ),
        ),
      );
}
