import 'package:brick_app/widgets/create_delete_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}

void showInputDialog(BuildContext context,
    {required String title,
    required String label,
    required Key inputFieldKey,
    required AsyncValueSetter<String> onOkButtonPress,
    required String okButtonText}) {
  String? input;
  showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => CreateDeleteDialog(
        title: title,
        content: TextFormField(
          key: inputFieldKey,
          decoration: InputDecoration(labelText: label),
          onChanged: (value) => setState(() => input = value),
        ),
        okButtonText: okButtonText,
        onOkButtonPress: input != null ? () => onOkButtonPress(input!) : null,
      ),
    ),
  );
}
