import 'package:brick_app/model/brick_set_list.dart';
import 'package:brick_app/model/rebrickable_model.dart';
import 'package:brick_app/pages/set_list_page.dart';
import 'package:brick_app/widgets/brick_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OverviewPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return FutureBuilder<List<BrickSetList>>(
        future: context.read<RebrickableModel>().getUsersSetLists(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: BrickAppBar(
                Text('My Set Lists (${snapshot.data!.length})'),
              ),
              body: Center(
                child: _createListView(snapshot.data!),
              ),
            );
          } else if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                title: Text('My Set Lists (error)'),
              ),
              body: Center(
                child: Text('An error occured while loading the set lists.'),
              ),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text('My Set Lists (loading)'),
              ),
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }

  ListView _createListView(List<BrickSetList> brickSetLists) =>
      brickSetLists.length != 0
          ? ListView.builder(
              key: ObjectKey('setList'),
              itemBuilder: (context, index) =>
                  _createListTile(context, brickSetLists[index]),
              itemCount: brickSetLists.length)
          : ListView(
              children: [Text('You have no set lists in your account.')]);

  ListTile _createListTile(BuildContext context, BrickSetList brickSetList) =>
      ListTile(
        leading: Icon(
          Icons.domain,
          color: Colors.red,
        ),
        title: Text(brickSetList.name),
        subtitle: Text('${brickSetList.numSets} sets'),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SetListPage(brickSetList: brickSetList))),
      );
}
