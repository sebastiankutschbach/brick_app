import 'package:brick_app/model/set_or_moc.dart';
import 'package:brick_app/pages/web_view_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SetsGridTile extends StatelessWidget {
  final SetOrMoc set;
  final List<Widget> buttons;

  const SetsGridTile(this.set, {this.buttons = const [], Key? key})
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
          onTap: buttons.isEmpty ? () {} : () => openUrl(context, set.url),
          contentPadding: const EdgeInsets.all(10),
          title: CachedNetworkImage(
            imageUrl: set.imgUrl,
            key: Key('tile_${set.setNum}'),
            progressIndicatorBuilder: (context, url, progress) =>
                LinearProgressIndicator(
              value: progress.progress,
            ),
          ),
          subtitle: Text(set.name),
        ),
        _createButtons(context),
      ],
    );
  }

  Widget _createButtons(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 10,
          ),
          ...buttons.map(
            (button) => Expanded(
              child: Padding(
                child: button,
                padding: const EdgeInsets.only(right: 10),
              ),
            ),
          ),
        ],
      );
}
