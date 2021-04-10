import 'package:brick_app/model/brick_set.dart';
import 'package:brick_app/widgets/brick_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SetViewPage extends StatelessWidget {
  final BrickSet brickSet;

  SetViewPage(this.brickSet);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BrickAppBar(
        Text(brickSet.name),
      ),
      body: WebView(
        initialUrl: brickSet.url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
