import 'package:brick_app/model/set_or_moc.dart';
import 'package:brick_app/widgets/sets_grid_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef OnTapCallback = void Function(dynamic);

class SetsGridView extends StatefulWidget {
  final List<SetOrMoc> sets;
  final bool withButtons;

  SetsGridView(this.sets, {this.withButtons = false});

  @override
  State<SetsGridView> createState() => _SetsGridViewState();
}

class _SetsGridViewState extends State<SetsGridView> {
  Widget build(BuildContext context) {
    return _createSetsView(context);
  }

  Widget _createSetsView(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Stack(
        children: [
          ListView.builder(
            itemCount: widget.sets.length,
            itemBuilder: (context, index) => SetsGridTile(
              widget.sets[index],
              withButtons: widget.withButtons,
            ),
          ),
        ],
      ),
    );
  }
}
