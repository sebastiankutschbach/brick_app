import 'package:brick_app/model/brick_set_list.dart';
import 'package:brick_app/model/rebrickable_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SetListPage extends StatelessWidget {
  final BrickSetList brickSet;

  SetListPage({@required this.brickSet});
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context
          .read<RebrickableModel>()
          .getUsersSetLists(listId: brickSet.id),
      builder: (context, snapshot) => Scaffold(
        appBar: AppBar(
          title: Text('${brickSet.name} ${_getTitleIndicator(snapshot)}'),
        ),
        body: Center(
          child: Text(_getTitleIndicator(snapshot)),
        ),
      ),
    );
  }

  String _getTitleIndicator(AsyncSnapshot snapshot) {
    if (!snapshot.hasData)
      return ' (loading)';
    else if (snapshot.hasError)
      return ' (error)';
    else
      return '';
  }
}
