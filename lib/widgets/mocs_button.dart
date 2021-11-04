import 'package:brick_app/model/set_or_moc.dart';
import 'package:brick_app/pages/moc_page.dart';
import 'package:brick_app/widgets/tile_button.dart';
import 'package:flutter/material.dart';

class MocsButton extends StatelessWidget {
  final SetOrMoc set;

  const MocsButton(this.set, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => TileButton(
        key: Key('mocs_button_${set.setNum}'),
        iconData: Icons.star,
        label: 'MOCs',
        onPressedCallback: () => Navigator.of(context).push(
          MaterialPageRoute(
            settings: const RouteSettings(name: 'mocsRoute'),
            builder: (context) => MocPage(set),
          ),
        ),
      );
}
