import 'package:brick_app/model/brick_set.dart';
import 'package:brick_app/model/brick_set_list.dart';
import 'package:brick_app/model/rebrickable_model.dart';
import 'package:brick_app/pages/set_view_page.dart';
import 'package:brick_app/widgets/brick_app_bar.dart';
import 'package:brick_app/widgets/sets_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'moc_page.dart';

class SetListPage extends StatelessWidget {
  final BrickSetList brickSetList;

  SetListPage({@required this.brickSetList});
  Widget build(BuildContext context) {
    return FutureBuilder<List<BrickSet>>(
      future: context
          .read<RebrickableModel>()
          .getSetsFromList(listId: brickSetList.id),
      builder: (context, snapshot) => Scaffold(
        appBar: BrickAppBar(
          Text('${brickSetList.name} ${_getTitleIndicator(snapshot)}'),
        ),
        body: Center(
          child: snapshot.hasData
              ? SetsGridView(
                  snapshot.data,
                  onTap: (argument) => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MocPage(argument),
                    ),
                  ),
                  onLongPress: (argument) => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SetViewPage(argument),
                    ),
                  ),
                )
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
}
