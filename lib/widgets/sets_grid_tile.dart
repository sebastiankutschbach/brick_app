import 'package:brick_app/model/set_or_moc.dart';
import 'package:brick_app/pages/moc_page.dart';
import 'package:brick_app/pages/part_list.dart';
import 'package:brick_app/pages/web_view_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'tile_button.dart';

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
            Image.network(
              set.imgUrl,
              key: Key('tile_${widget.set.setNum}'),
            ),
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
          TileButton(
            key: Key('home_button_${set.setNum}'),
            iconData: Icons.home,
            label: 'Sets',
            onPressedCallback: () => _openUrl(context, set.url),
          ),
          SizedBox(
            height: 30,
          ),
          TileButton(
            key: Key('mocs_button_${set.setNum}'),
            iconData: Icons.star,
            label: 'MOCs',
            onPressedCallback: () => Navigator.of(context).push(
              MaterialPageRoute(
                settings: RouteSettings(name: 'mocsRoute'),
                builder: (context) => MocPage(set),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          TileButton(
            key: Key('parts_button_${set.setNum}'),
            iconData: Icons.grain,
            label: 'Parts',
            onPressedCallback: () => Navigator.of(context).push(
              MaterialPageRoute(
                settings: RouteSettings(name: 'partsRoute'),
                builder: (context) => PartList(set),
              ),
            ),
          ),
        ],
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
