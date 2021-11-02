import 'package:brick_app/model/brick_set.dart';
import 'package:brick_app/model/brick_set_list.dart';
import 'package:brick_app/model/rebrickable_model.dart';
import 'package:brick_app/widgets/brick_app_bar.dart';
import 'package:brick_app/widgets/sets_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SetListPage extends StatefulWidget {
  final BrickSetList brickSetList;

  const SetListPage({required this.brickSetList, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SetListPageState();
}

class _SetListPageState extends State<SetListPage> {
  Future<List<BrickSet>>? _brickSetsFuture;

  @override
  initState() {
    super.initState();
    _refreshBrickSets(context, widget.brickSetList.id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BrickSet>>(
      future: _brickSetsFuture,
      builder: (context, snapshot) => Scaffold(
        appBar: BrickAppBar(
          Text('${widget.brickSetList.name} ${_getTitleIndicator(snapshot)}'),
        ),
        body: Center(
          child: snapshot.hasData
              ? RefreshIndicator(
                  child: SetsGridView(
                    snapshot.data!,
                    withButtons: true,
                    key: const Key('setList'),
                  ),
                  onRefresh: () =>
                      _refreshBrickSets(context, widget.brickSetList.id),
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

  Future<void> _refreshBrickSets(
      BuildContext context, int brickSetListId) async {
    setState(() {
      _brickSetsFuture = context
          .read<RebrickableModel>()
          .getSetsFromList(listId: brickSetListId);
    });
  }
}
