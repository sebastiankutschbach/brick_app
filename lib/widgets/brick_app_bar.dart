import 'package:brick_app/pages/settings_page.dart';
import 'package:flutter/material.dart';

class BrickAppBar extends StatelessWidget with PreferredSizeWidget {
  final Widget title;
  @override
  final Size preferredSize;

  BrickAppBar(this.title, {Key key})
      : preferredSize = Size.fromHeight(50.0),
        super(key: key);

  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      actions: [
        _createSettingsButton(context),
      ],
    );
  }

  IconButton _createSettingsButton(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SettingsPage()));
        },
        icon: Icon(Icons.settings));
  }
}
