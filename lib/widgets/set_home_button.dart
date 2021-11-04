import 'package:brick_app/model/set_or_moc.dart';
import 'package:brick_app/pages/web_view_page.dart';
import 'package:brick_app/widgets/tile_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SetHomeButton extends StatelessWidget {
  final SetOrMoc set;

  const SetHomeButton(this.set, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => TileButton(
        key: Key('home_button_${set.setNum}'),
        iconData: Icons.home,
        label: 'Sets',
        onPressedCallback: () => openUrl(context, set.url),
      );
}

void openUrl(BuildContext context, String url) {
  kIsWeb
      ? launch(url)
      : Navigator.of(context).push(MaterialPageRoute(
          settings: const RouteSettings(name: 'setRoute'),
          builder: (_) => WebViewPage(url),
        ));
}
