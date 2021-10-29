import 'package:brick_app/pages/login_page.dart';
import 'package:brick_app/pages/settings_page.dart';
import 'package:brick_app/service/preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BrickAppBar extends StatelessWidget with PreferredSizeWidget {
  final Widget title;
  @override
  final Size preferredSize;

  final bool showLogoutButton;
  final List<IconButton> additionalButtons;

  BrickAppBar(this.title,
      {Key? key,
      this.showLogoutButton = true,
      this.additionalButtons = const []})
      : preferredSize = const Size.fromHeight(50.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(title: title, actions: [
      ...additionalButtons,
      _createSettingsButton(context),
      showLogoutButton ? _createLogoutButton(context) : Container(),
    ]);
  }

  IconButton _createSettingsButton(BuildContext context) {
    return IconButton(
        key: const Key('brickAppBarSettings'),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SettingsPage()));
        },
        icon: const Icon(Icons.settings));
  }

  IconButton _createLogoutButton(BuildContext context) {
    return IconButton(
        key: const Key('brickAppBarLogout'),
        onPressed: () {
          context.read<PreferencesService>().userToken = '';
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const LoginPage()));
        },
        icon: const Icon(Icons.logout));
  }
}
