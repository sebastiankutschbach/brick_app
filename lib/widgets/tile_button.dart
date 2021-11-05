import 'package:flutter/material.dart';

typedef OnPressedCallback = void Function();

class TileButton extends StatelessWidget {
  final IconData iconData;
  final String label;
  final OnPressedCallback onPressedCallback;

  const TileButton({
    required Key key,
    required this.iconData,
    required this.label,
    required this.onPressedCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(iconData, color: Colors.white),
      label: Text(label),
      onPressed: onPressedCallback,
    );
  }
}
