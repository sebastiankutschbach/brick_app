import 'package:brick_app/model/brick_set.dart';
import 'package:brick_app/model/inventory.dart';
import 'package:brick_app/model/rebrickable_model.dart';
import 'package:brick_app/widgets/brick_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum SortDirection { ascending, descending }

class PartList extends StatefulWidget {
  final BrickSet brickSet;

  PartList(this.brickSet);

  @override
  State<PartList> createState() => _PartListState();
}

class _PartListState extends State<PartList> {
  SortDirection sortDirection = SortDirection.descending;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BrickAppBar(
        Text('Parts of Set: ${widget.brickSet.name}'),
        additionalButtons: [
          _createSortButton(context),
        ],
      ),
      body: FutureBuilder<List<Inventory>>(
        future: context
            .read<RebrickableModel>()
            .getInventoriesOfSet(setNum: widget.brickSet.setNum),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Center(
              child: _createListView(
                _sortedList(snapshot.data!),
              ),
            );
          }
        },
      ),
    );
  }

  List<Inventory> _sortedList(List<Inventory> inventories) {
    return inventories
      ..sort((itemA, itemB) {
        if (sortDirection == SortDirection.descending) {
          return itemB.quantity.compareTo(itemA.quantity);
        } else {
          return itemA.quantity.compareTo(itemB.quantity);
        }
      });
  }

  Widget _createListView(List<Inventory> inventories) {
    return ListView.builder(
      itemBuilder: (context, index) => _createListTile(inventories[index]),
      itemCount: inventories.length,
    );
  }

  Widget _createListTile(Inventory inventory) => ListTile(
        leading: Text('${inventory.quantity}x'),
        title: Text(
            '${inventory.part.name}${inventory.isSpare ? " (spare part)" : ""}'),
        subtitle: Text('${inventory.part.partNum}'),
        trailing: inventory.part.partImgUrl == null
            ? Text("Image n/a") // TODO can be replaced with image e.g.
            : Image.network(inventory.part.partImgUrl!),
        tileColor: inventory.isSpare ? Color(0xFFEEEEEE) : Colors.white,
      );

  IconButton _createSortButton(BuildContext context) {
    return IconButton(
        key: ObjectKey('brickAppBarSort'),
        onPressed: () {
          setState(() {
            sortDirection == SortDirection.ascending
                ? sortDirection = SortDirection.descending
                : sortDirection = SortDirection.ascending;
          });
        },
        icon: Icon(Icons.sort));
  }
}
