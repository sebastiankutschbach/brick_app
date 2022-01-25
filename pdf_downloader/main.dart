import 'dart:developer';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

import 'dart:io';

import 'package:http/http.dart';

main() async {
  final mainDir = Directory('moc_html');
  final subdirs = mainDir
      .listSync()
      .where((element) => element is Directory)
      .cast<Directory>();

  for (final Directory subdir in subdirs) {
    await downloadPdfsForSet(subdir);
  }
}

downloadPdfsForSet(Directory dir) async {
  Directory(dir.path.replaceAll('html', 'pdf')).createSync(recursive: true);
  for (final file in dir.listSync()) {
    final pathElements = file.path.split('/');
    final String setName = pathElements[pathElements.length - 2];
    final String mocName = pathElements.last.replaceFirst('.html', '');
    final fileContent = File(file.path);
    final document = parse(fileContent.readAsStringSync());
    final element =
        document.getElementsByTagName('a').cast<Element?>().firstWhere(
              (element) =>
                  element!.attributes.containsKey('href') &&
                  element.attributes['href']!.contains('.pdf'),
              orElse: () => null,
            );
    downloadPdf(element, setName, mocName);
  }
}

downloadPdf(Element? element, String setName, String mocName) async {
  if (element != null) {
    String pdfUrlString =
        element.attributes['href']!.replaceFirst('/external/view/?url=', '');

    pdfUrlString = pdfUrlString.substring(0, pdfUrlString.indexOf('&'));
    final Uri pdfUrl = Uri.parse(Uri.decodeFull(pdfUrlString));
    final response = await get(pdfUrl);
    if (response.statusCode != 200) {
      log('Error while downloading pdf for $mocName: ${response.statusCode}');
    }
    final String pdfFileName = './moc_pdf/$setName/$mocName.pdf';
    File(pdfFileName).writeAsBytesSync(response.bodyBytes);
    log('Pdf file for $mocName downloaded successful');
  } else {
    log('Link not found in $mocName');
  }
}
