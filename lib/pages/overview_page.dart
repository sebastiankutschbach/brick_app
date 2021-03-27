import 'package:brick_app/model/brick_set.dart';
import 'package:brick_app/model/rebrickable_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OverviewPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return FutureBuilder(
        future:
            //Future.delayed(Duration(milliseconds: 10), () => []),
            context.read<RebrickableModel>().getUsersSetLists(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                title: Text('My Set Lists (${snapshot.data.length})'),
              ),
              body: Center(
                child: _createListView(snapshot.data),
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

  ListView _createListView(List<BrickSet> brickSets) => brickSets.length != 0
      ? ListView.builder(
          key: ObjectKey('setList'),
          itemBuilder: (context, index) =>
              _createListTile(context, brickSets[index]),
          itemCount: brickSets.length)
      : ListView(children: [Text('You have no set lists in your account.')]);

  ListTile _createListTile(BuildContext context, BrickSet brickSet) => ListTile(
        leading: Icon(
          Icons.domain,
          color: Colors.red,
        ),
        title: Text(brickSet.name),
        subtitle: Text('${brickSet.numSets} sets'),
      );
}
