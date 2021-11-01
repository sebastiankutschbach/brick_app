import 'package:brick_app/model/brick_set_list.dart';
import 'package:brick_app/model/rebrickable_model.dart';
import 'package:brick_app/pages/set_list_page.dart';
import 'package:brick_app/service/http_utils.dart';
import 'package:brick_app/widgets/brick_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OverviewPage extends StatefulWidget {
  const OverviewPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  @override
  Widget build(BuildContext context) {
    final model = context.read<RebrickableModel>();
    return FutureBuilder<List<BrickSetList>>(
        future: model.getUsersSetLists(),
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

  ListView _createListView(List<BrickSetList> brickSetLists) =>
      brickSetLists.isNotEmpty
          ? ListView.builder(
              key: const Key('setList'),
              itemBuilder: (context, index) =>
                  _createListTile(context, brickSetLists[index]),
              itemCount: brickSetLists.length)
          : ListView(
              children: const [
                Text('You have no set lists in your account.'),
              ],
            );

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
          key: const Key('deleteSetList'),
          icon: const Icon(Icons.delete),
          onPressed: () => showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Delete Set List'),
              content:
                  const Text('''Do you really want to delete this set list? 
This deletes the list itself and all sets in this list.'''),
              actions: [
                ElevatedButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                ElevatedButton(
                    child: const Text('Delete'),
                    onPressed: () {
                      final model = context.read<RebrickableModel>();
                      model.deleteSetList(setListId: brickSetList.id);
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('List deleted successfully'),
                        ),
                      );
                      setState(() {
                        // force reload
                        httpCache.clear();
                      });
                    }),
              ],
            ),
          ),
        ),
      );

  void _showDialog(BuildContext context) {
    String? setListName;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Create new Set List'),
          content: Form(
            child: TextFormField(
              key: const Key('setListName'),
              decoration: const InputDecoration(labelText: 'Set list name'),
              onChanged: (value) => setState(() => setListName = value),
              validator: (value) =>
                  value!.isEmpty ? 'Set list name cannot be empty' : null,
            ),
          ),
          actions: [
            ElevatedButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: const Text('Create'),
              onPressed: setListName != null
                  ? () {
                      context
                          .read<RebrickableModel>()
                          .addSetList(setListName: setListName!);
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('List created successfully'),
                        ),
                      );
                      setState(() {
                        // force reload
                      });
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
