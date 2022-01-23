import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CreateDeleteDialog extends StatelessWidget {
  final String title;
  final Widget content;

  final String okButtonText;
  final AsyncCallback? onOkButtonPress;

  const CreateDeleteDialog(
      {required this.title,
      required this.content,
      required this.okButtonText,
      this.onOkButtonPress,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(title),
        content: content,
        actions: [
          ElevatedButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.red),
            child: Text(okButtonText),
            onPressed: onOkButtonPress,
          ),
        ],
      );
}
