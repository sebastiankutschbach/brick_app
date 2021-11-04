import 'package:brick_app/model/brick_set.dart';
import 'package:brick_app/model/brick_set_list.dart';
import 'package:brick_app/model/rebrickable_model.dart';
import 'package:brick_app/pages/utils.dart';
import 'package:brick_app/widgets/brick_app_bar.dart';
import 'package:brick_app/widgets/create_delete_dialog.dart';
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
                    setListId: widget.brickSetList.id,
                    key: const Key('setList'),
                  ),
                  onRefresh: () =>
                      _refreshBrickSets(context, widget.brickSetList.id),
                )
              : const CircularProgressIndicator(),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => _showDialog(context),
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

  void _showDialog(BuildContext context) {
    String? setId;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => CreateDeleteDialog(
          title: 'Add Set to List',
          content: TextFormField(
            key: const Key('setIdInput'),
            decoration: const InputDecoration(labelText: 'Set id'),
            onChanged: (value) => setState(() => setId = value),
            validator: (value) =>
                value!.isEmpty ? 'Set list name cannot be empty' : null,
          ),
          okButtonText: 'Create',
          onOkButtonPress: setId != null
              ? () async {
                  await context.read<RebrickableModel>().addSetToList(
                      setListId: widget.brickSetList.id, setId: setId!);
                  await _refreshBrickSets(context, widget.brickSetList.id);
                  Navigator.of(context).pop();
                  showSnackBar(context, 'Set added successfully');
                }
              : null,
        ),
      ),
    );
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
