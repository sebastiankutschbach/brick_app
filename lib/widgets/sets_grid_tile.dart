import 'package:brick_app/model/set_or_moc.dart';
import 'package:brick_app/pages/moc_page.dart';
import 'package:brick_app/pages/part_list.dart';
import 'package:brick_app/pages/web_view_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
      onTap: () => setState(() {
        _clickedSetNum =
            _clickedSetNum == widget.set.setNum ? null : widget.set.setNum;
      }),
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
                color: Theme.of(context).colorScheme.secondary, width: 2),
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          child: _createSetTile(context, widget.set,
              selected: _clickedSetNum == widget.set.setNum),
        ),
      ),
    );
  }

  Widget _createSetTile(context, set, {required selected}) {
    return selected
        ? _createButtons(context, set)
        : ListTile(
            contentPadding: EdgeInsets.all(10),
            title: CachedNetworkImage(
              imageUrl: set.imgUrl,
              key: Key('tile_${widget.set.setNum}'),
            ),
            subtitle: Column(
              children: [
                Text(set.name),
              ],
            ),
          );
  }

  Widget _createButtons(BuildContext context, set) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TileButton(
              key: Key('home_button_${set.setNum}'),
              iconData: Icons.home,
              label: 'Sets',
              onPressedCallback: () => _openUrl(context, set.url),
            ),
          ),
          Expanded(
            child: TileButton(
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
          ),
          Expanded(
            child: TileButton(
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
