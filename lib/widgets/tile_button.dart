import 'package:flutter/material.dart';

typedef OnPressedCallback = void Function();

class TileButton extends StatelessWidget {
  final Key key;
  final IconData iconData;
  final String label;
  final OnPressedCallback onPressedCallback;

  TileButton({
    required this.key,
    required this.iconData,
    required this.label,
    required this.onPressedCallback,
  });

  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(iconData, color: Colors.white),
      label: Text(label),
      onPressed: onPressedCallback,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 30), // double.infinity is the width and 30 is the height
      ),
    );
  }
}
