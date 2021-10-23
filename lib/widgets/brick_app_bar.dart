import 'package:brick_app/pages/login_page.dart';
import 'package:brick_app/pages/settings_page.dart';
import 'package:brick_app/service/preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BrickAppBar extends StatelessWidget with PreferredSizeWidget {
  final Widget title;
  @override
  final Size preferredSize;

  final showLogoutButton;
  final List<IconButton> additionalButtons;

  BrickAppBar(this.title,
      {Key? key,
      this.showLogoutButton = true,
      this.additionalButtons = const []})
      : preferredSize = Size.fromHeight(50.0),
        super(key: key);

  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      actions: []
        ..addAll(additionalButtons)
        ..addAll([
          _createSettingsButton(context),
          showLogoutButton ? _createLogoutButton(context) : Container(),
        ]),
    );
  }

  IconButton _createSettingsButton(BuildContext context) {
    return IconButton(
        key: ObjectKey('brickAppBarSettings'),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SettingsPage()));
        },
        icon: Icon(Icons.settings));
  }

  IconButton _createLogoutButton(BuildContext context) {
    return IconButton(
        key: ObjectKey('brickAppBarLogout'),
        onPressed: () {
          context.read<PreferencesService>().userToken = '';
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        },
        icon: Icon(Icons.logout));
  }
}
