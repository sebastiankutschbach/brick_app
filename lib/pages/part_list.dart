import 'package:brick_app/model/brick_set.dart';
import 'package:brick_app/model/inventory.dart';
import 'package:brick_app/model/rebrickable_model.dart';
import 'package:brick_app/widgets/brick_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PartList extends StatelessWidget {
  final BrickSet brickSet;

  PartList(this.brickSet);

  Widget build(BuildContext context) {
    return FutureBuilder<List<Inventory>>(
      future: context
          .read<RebrickableModel>()
          .getInventoriesOfSet(setNum: brickSet.setNum),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            appBar: BrickAppBar(Text('Parts of Set: ${brickSet.name}')),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return Scaffold(
            appBar: BrickAppBar(Text('Parts of Set: ${brickSet.name}')),
            body: Center(
              child: _createListView(snapshot.data),
            ),
          );
        }
      },
    );
  }

  Widget _createListView(List<Inventory> inventories) {
    return ListView.builder(
      itemBuilder: (context, index) => _createListTile(inventories[index]),
      itemCount: inventories.length,
    );
  }

  Widget _createListTile(Inventory inventory) => ListTile(
        leading: Text('${inventory.quantity}x'),
        title: Text('${inventory.part.name}${inventory.isSpare?" (spare part)":""}'),
        subtitle: Text('${inventory.part.partNum}'),
        trailing: inventory.part.partImgUrl == null
            ? Text("Image n/a") // TODO can be replaced with image e.g.
            : Image.network(inventory.part.partImgUrl),
        tileColor: inventory.isSpare ? Color(0xFFEEEEEE) : Colors.white,
      );
}
