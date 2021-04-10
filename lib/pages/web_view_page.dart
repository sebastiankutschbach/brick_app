import 'package:brick_app/widgets/brick_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatelessWidget {
  final String url;

  WebViewPage(this.url);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BrickAppBar(
        Text('Rebrickable'),
      ),
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
