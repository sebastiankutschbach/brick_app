import 'package:brick_app/model/brick_set.dart';
import 'package:brick_app/model/moc.dart';
import 'package:brick_app/model/rebrickable_model.dart';
import 'package:brick_app/widgets/brick_app_bar.dart';
import 'package:brick_app/widgets/sets_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MocPage extends StatefulWidget {
  final BrickSet brickSet;

  const MocPage(this.brickSet, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MocPageState();
}

class _MocPageState extends State<MocPage> {
  Future<List<Moc>>? _setOrMocListFuture;

  @override
  void initState() {
    super.initState();
    _refreshMocList(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BrickAppBar(
        Text(widget.brickSet.name),
      ),
      body: FutureBuilder<List<Moc>>(
        future: _setOrMocListFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return RefreshIndicator(
              child: SetsGridView(
                snapshot.data!,
                key: const Key('setGridView'),
                withButtons: false,
              ),
              onRefresh: () => _refreshMocList(context),
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }

  Future<void> _refreshMocList(BuildContext context) async {
    setState(() {
      _setOrMocListFuture = context
          .read<RebrickableModel>()
          .getMocsFromSet(setNum: widget.brickSet.setNum);
    });
  }
}
