import 'package:brick_app/model/brick_set.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SetViewPage extends StatelessWidget {
  final BrickSet brickSet;

  SetViewPage(this.brickSet);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(brickSet.name),
      ),
      body: WebView(
        initialUrl: '${brickSet.setUrl}?inventory=1#alt_builds',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
