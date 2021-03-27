import 'package:brick_app/model/brick_set.dart';
import 'package:brick_app/model/brick_set_list.dart';
import 'package:brick_app/model/rebrickable_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SetListPage extends StatelessWidget {
  final BrickSetList brickSetList;

  SetListPage({@required this.brickSetList});
  Widget build(BuildContext context) {
    return FutureBuilder<List<BrickSet>>(
      future: context
          .read<RebrickableModel>()
          .getSetsFromList(listId: brickSetList.id),
      builder: (context, snapshot) => Scaffold(
        appBar: AppBar(
          title: Text('${brickSetList.name} ${_getTitleIndicator(snapshot)}'),
        ),
        body: Center(
          child: snapshot.hasData
              ? _createSetsView(context, snapshot.data)
              : CircularProgressIndicator(),
        ),
      ),
    );
  }

  String _getTitleIndicator(AsyncSnapshot snapshot) {
    if (!snapshot.hasData)
      return '(loading)';
    else if (snapshot.hasError)
      return '(error)';
    else
      return '';
  }

  Widget _createSetsView(BuildContext context, List<BrickSet> brickSets) {
    return GridView.builder(
      itemCount: brickSets.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 10, mainAxisSpacing: 10, crossAxisCount: 3),
      itemBuilder: (context, index) => _buildTile(
        context,
        brickSets[index],
      ),
    );
  }

  Widget _buildTile(BuildContext context, BrickSet brickSet) {
    return Column(key: ObjectKey('setTile_${brickSet.setNum}'), children: [
      Image.network(
        brickSet.setImgUrl,
      ),
    ]);
  }
}
