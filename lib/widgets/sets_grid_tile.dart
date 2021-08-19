import 'package:brick_app/model/set_or_moc.dart';
import 'package:brick_app/pages/moc_page.dart';
import 'package:brick_app/pages/part_list.dart';
import 'package:brick_app/pages/web_view_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SetsGridTile extends StatefulWidget {
  final SetOrMoc set;
  final bool withButtons;

  SetsGridTile(this.set, {this.withButtons = false});

  @override
  State<SetsGridTile> createState() => _SetGridTileState();
}

class _SetGridTileState extends State<SetsGridTile> {
  String? _clickedSetNum;

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _clickedSetNum == widget.set.setNum
          ? _clickedSetNum = null
          : _clickedSetNum = widget.set.setNum),
      child: DecoratedBox(
        key: Key('tile_${widget.set.setNum}'),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
              color: Theme.of(context).colorScheme.secondary, width: 2),
          borderRadius: BorderRadius.all(
            Radius.circular(16.0),
          ),
        ),
        child: _createSetTile(context, widget.set,
            withOverlay: _clickedSetNum == widget.set.setNum),
      ),
    );
  }

  Widget _createSetTile(context, set, {required withOverlay}) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(set.imgUrl),
            withOverlay ? _createButtons(context, set) : Container(),
          ],
        ),
      ),
    );
  }

  Widget _createButtons(BuildContext context, set) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _createButton(
            context: context,
            iconData: Icons.home,
            label: 'Sets',
            onPressed: () => _openUrl(context, set.url),
          ),
          SizedBox(
            height: 30,
          ),
          _createButton(
            context: context,
            iconData: Icons.star,
            label: 'MOCs',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                settings: RouteSettings(name: 'mocsRoute'),
                builder: (context) => MocPage(set),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          _createButton(
            context: context,
            iconData: Icons.grain,
            label: 'Parts',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                settings: RouteSettings(name: 'partsRoute'),
                builder: (context) => PartList(set),
              ),
            ),
          ),
        ],
      );

  Widget _createButton({
    required BuildContext context,
    required IconData iconData,
    required String label,
    required onPressed,
  }) =>
      ElevatedButton.icon(
        icon: Icon(iconData, color: Colors.white),
        label: Text(label),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          fixedSize: Size.fromWidth(200),
          padding: EdgeInsets.all(16),
          textStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      );

  void _openUrl(BuildContext context, String url) {
    kIsWeb
        ? launch(url)
        : Navigator.of(context).push(MaterialPageRoute(
            settings: RouteSettings(name: 'setRoute'),
            builder: (_) => WebViewPage(url),
          ));
  }
}
