import 'package:brick_app/model/set_or_moc.dart';
import 'package:brick_app/pages/moc_page.dart';
import 'package:brick_app/pages/part_list.dart';
import 'package:brick_app/pages/web_view_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'tile_button.dart';

class SetsGridTile extends StatelessWidget {
  final SetOrMoc set;
  final bool withButtons;

  const SetsGridTile(this.set, {this.withButtons = false, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
              color: Theme.of(context).colorScheme.secondary, width: 2),
          borderRadius: const BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        child: _createSetTile(context, set),
      ),
    );
  }

  Widget _createSetTile(context, set) {
    return Column(
      children: [
        ListTile(
          onTap: withButtons ? () {} : () => _openUrl(context, set.url),
          contentPadding: const EdgeInsets.all(10),
          title: CachedNetworkImage(
            imageUrl: set.imgUrl,
            key: Key('tile_${set.setNum}'),
            progressIndicatorBuilder: (context, url, progress) =>
                LinearProgressIndicator(
              value: progress.progress,
            ),
          ),
          subtitle: Column(
            children: [
              Text(set.name),
            ],
          ),
        ),
        withButtons ? _createButtons(context, set) : Container(),
      ],
    );
  }

  Widget _createButtons(BuildContext context, set) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: TileButton(
              key: Key('home_button_${set.setNum}'),
              iconData: Icons.home,
              label: 'Sets',
              onPressedCallback: () => _openUrl(context, set.url),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: TileButton(
              key: Key('mocs_button_${set.setNum}'),
              iconData: Icons.star,
              label: 'MOCs',
              onPressedCallback: () => Navigator.of(context).push(
                MaterialPageRoute(
                  settings: const RouteSettings(name: 'mocsRoute'),
                  builder: (context) => MocPage(set),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: TileButton(
              key: Key('parts_button_${set.setNum}'),
              iconData: Icons.grain,
              label: 'Parts',
              onPressedCallback: () => Navigator.of(context).push(
                MaterialPageRoute(
                  settings: const RouteSettings(name: 'partsRoute'),
                  builder: (context) => PartList(set),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      );

  void _openUrl(BuildContext context, String url) {
    kIsWeb
        ? launch(url)
        : Navigator.of(context).push(MaterialPageRoute(
            settings: const RouteSettings(name: 'setRoute'),
            builder: (_) => WebViewPage(url),
          ));
  }
}
