import 'package:brick_app/model/moc.dart';
import 'package:brick_app/model/rebrickable_model.dart';
import 'package:brick_app/model/set_or_moc.dart';
import 'package:brick_app/pages/pdf_page.dart';
import 'package:brick_app/widgets/brick_app_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MocPage extends StatefulWidget {
  final SetOrMoc brickSet;

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
              child: ListView.builder(
                itemBuilder: (context, index) =>
                    _buildListTile(context, snapshot.data![index]),
                itemCount: snapshot.data?.length,
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

  _buildListTile(BuildContext context, Moc moc) {
    return ListTile(
      onTap: moc.hasInstruction
          ? () async => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PdfPage(
                    setNum: widget.brickSet.setNum,
                    mocNum: moc.setNum,
                  ),
                ),
              )
          : null,
      tileColor: moc.hasInstruction ? Colors.white : Colors.grey,
      title: SizedBox(
        height: 200,
        width: 200,
        child: CachedNetworkImage(
          imageUrl: moc.imgUrl,
          fit: BoxFit.scaleDown,
        ),
      ),
      subtitle: Text(moc.name),
    );
  }
}
