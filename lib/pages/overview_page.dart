import 'package:brick_app/model/brick_set_list.dart';
import 'package:brick_app/model/rebrickable_model.dart';
import 'package:brick_app/pages/set_list_page.dart';
import 'package:brick_app/widgets/brick_app_bar.dart';
import 'package:brick_app/widgets/create_delete_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OverviewPage extends StatefulWidget {
  const OverviewPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  Future<List<BrickSetList>>? _brickSetListsFuture;

  @override
  initState() {
    super.initState();
    _refreshBrickSetList(context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BrickSetList>>(
        future: _brickSetListsFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: BrickAppBar(
                Text('My Set Lists (${snapshot.data!.length})'),
              ),
              body: Center(
                child: _createListView(snapshot.data!),
              ),
              floatingActionButton: FloatingActionButton(
                key: const Key('createSetList'),
                child: const Icon(Icons.add),
                onPressed: () => _showDialog(context),
              ),
            );
          } else if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('My Set Lists (error)'),
              ),
              body: const Center(
                child: Text('An error occured while loading the set lists.'),
              ),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                title: const Text('My Set Lists (loading)'),
              ),
              body: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }

  Widget _createListView(List<BrickSetList> brickSetLists) => RefreshIndicator(
      child: brickSetLists.isNotEmpty
          ? ListView.builder(
              key: const Key('overviewList'),
              itemBuilder: (context, index) =>
                  _createListTile(context, brickSetLists[index]),
              itemCount: brickSetLists.length)
          : ListView(
              children: const [
                Text('You have no set lists in your account.'),
              ],
            ),
      onRefresh: () => _refreshBrickSetList(context));

  ListTile _createListTile(BuildContext context, BrickSetList brickSetList) =>
      ListTile(
        key: Key('overviewListTile_${brickSetList.name}'),
        leading: const Icon(
          Icons.domain,
          color: Colors.red,
        ),
        title: Text(brickSetList.name),
        subtitle: Text('${brickSetList.numSets} sets'),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SetListPage(brickSetList: brickSetList),
          ),
        ),
        trailing: IconButton(
          key: Key('deleteSetList_${brickSetList.name}'),
          icon: const Icon(Icons.delete),
          onPressed: () => showDialog(
            context: context,
            builder: (context) => CreateDeleteDialog(
              title: 'Delete Set List',
              content:
                  const Text('''Do you really want to delete this set list? 
This deletes the list itself and all sets in this list.'''),
              okButtonText: 'Delete',
              onOkButtonPress: () async {
                final model = context.read<RebrickableModel>();
                await model.deleteSetList(setListId: brickSetList.id);
                Navigator.of(context).pop();
                _showSnackBar(context, 'List deleted successfully');
                await _refreshBrickSetList(context);
              },
            ),
          ),
        ),
      );

  void _showDialog(BuildContext context) {
    String? setListName;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => CreateDeleteDialog(
          title: 'Create new Set List',
          content: TextFormField(
            key: const Key('setListName'),
            decoration: const InputDecoration(labelText: 'Set list name'),
            onChanged: (value) => setState(() => setListName = value),
            validator: (value) =>
                value!.isEmpty ? 'Set list name cannot be empty' : null,
          ),
          okButtonText: 'Create',
          onOkButtonPress: setListName != null
              ? () async {
                  await context
                      .read<RebrickableModel>()
                      .addSetList(setListName: setListName!);
                  Navigator.of(context).pop();
                  _showSnackBar(context, 'List created successfully');
                  await _refreshBrickSetList(context);
                }
              : null,
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  Future<void> _refreshBrickSetList(BuildContext context) async {
    setState(() {
      _brickSetListsFuture =
          context.read<RebrickableModel>().getUsersSetLists();
    });
  }
}
