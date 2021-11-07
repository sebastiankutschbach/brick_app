import 'package:brick_app/widgets/brick_app_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatelessWidget {
  final String url;

  const WebViewPage(this.url, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BrickAppBar(
        const Text('Rebrickable'),
      ),
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}

void openUrl(BuildContext context, String url) {
  kIsWeb
      ? launch(url)
      : Navigator.of(context).push(MaterialPageRoute(
          settings: const RouteSettings(name: 'setRoute'),
          builder: (_) => WebViewPage(url),
        ));
}
