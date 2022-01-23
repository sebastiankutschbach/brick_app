import 'package:brick_app/model/rebrickable_model.dart';
import 'package:brick_app/model/set_or_moc.dart';
import 'package:brick_app/presentation/widgets/brick_app_bar.dart';
import 'package:brick_app/presentation/widgets/sets_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MocPage extends StatefulWidget {
  final SetOrMoc brickSet;

  const MocPage(this.brickSet, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MocPageState();
}

class _MocPageState extends State<MocPage> {
  Future<List<SetOrMoc>>? _setOrMocListFuture;

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
      body: FutureBuilder<List<SetOrMoc>>(
        future: _setOrMocListFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return RefreshIndicator(
              child:
                  SetsGridView(snapshot.data!, key: const Key('setGridView')),
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
