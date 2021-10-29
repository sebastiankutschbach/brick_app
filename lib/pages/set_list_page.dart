import 'package:brick_app/model/brick_set.dart';
import 'package:brick_app/model/brick_set_list.dart';
import 'package:brick_app/model/rebrickable_model.dart';
import 'package:brick_app/widgets/brick_app_bar.dart';
import 'package:brick_app/widgets/sets_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SetListPage extends StatelessWidget {
  final BrickSetList brickSetList;

  const SetListPage({required this.brickSetList, Key? key}) : super(key: key);

  @override
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
                  snapshot.data!,
                  withButtons: true,
                )
              : const CircularProgressIndicator(),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {},
        ),
      ),
    );
  }

  String _getTitleIndicator(AsyncSnapshot snapshot) {
    if (!snapshot.hasData) {
      return '(loading)';
    } else if (snapshot.hasError) {
      return '(error)';
    } else {
      return '';
    }
  }
}
