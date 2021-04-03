import 'package:brick_app/model/set_or_moc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef OnTapFunction = void Function(dynamic);

class SetsGridView extends StatelessWidget {
  final List<SetOrMoc> sets;
  final OnTapFunction onTap;

  SetsGridView(this.sets, this.onTap);
  Widget build(BuildContext context) {
    return _createSetsView(context);
  }

  Widget _createSetsView(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: GridView.builder(
        itemCount: sets.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 16, mainAxisSpacing: 16, crossAxisCount: 3),
        itemBuilder: (context, index) => _buildTile(
          context,
          sets[index],
        ),
      ),
    );
  }

  Widget _buildTile(BuildContext context, set) {
    return GestureDetector(
      onTap: () => onTap(set),
      child: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              set.imgUrl,
            ),
          ),
          color: Colors.white,
          border: Border.all(color: Colors.blueGrey, width: 1),
          borderRadius: BorderRadius.all(
            Radius.circular(16.0),
          ),
        ),
      ),
    );
  }
}
