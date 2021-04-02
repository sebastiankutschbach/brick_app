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
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: GridView.builder(
        itemCount: brickSets.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 16, mainAxisSpacing: 16, crossAxisCount: 3),
        itemBuilder: (context, index) => _buildTile(
          context,
          brickSets[index],
        ),
      ),
    );
  }

  Widget _buildTile(BuildContext context, BrickSet brickSet) {
    return GestureDetector(
      onTap: () => print(brickSet.name),
      child: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              brickSet.setImgUrl,
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
