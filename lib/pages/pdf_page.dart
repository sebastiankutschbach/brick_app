import 'dart:io';

import 'package:brick_app/widgets/brick_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

class PdfPage extends StatelessWidget {
  late PdfController _controller;

  PdfPage(File pdfFile, {Key? key}) : super(key: key) {
    _controller = PdfController(document: PdfDocument.openFile(pdfFile.path));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: BrickAppBar(const Text('PDF')),
        body: PdfView(controller: _controller),
      );
}
