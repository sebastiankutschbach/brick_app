import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:dotenv/dotenv.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

import 'dart:io';

const mocHtmlDirName = 'moc_html';
const mocPdfDirName = 'moc_pdf';

main() async {
  load();
  final Dio dio = Dio(
    BaseOptions(
      headers: {
        Headers.acceptHeader: Headers.jsonContentType,
        'Authorization': 'key ${env["API_KEY"]}'
      },
    ),
  );
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      log('REQUEST[${options.method}] => PATH: ${options.path}');
      return handler.next(options);
    },
  ));
  final String userToken = await getUserToken(dio);
  final List<String> allSetNums = await getAllSetsNum(dio, userToken);

  log('All sets of user: ${allSetNums.join(', ')}');

  for (final setNum in allSetNums) {
    log('Starting with setNum: $setNum');
    await downloadMocHtmls(dio, setNum);
    final setHtmlDir = Directory('./$mocHtmlDirName/$setNum');
    await downloadPdfs(dio, setHtmlDir);
    log('Finished setNum: $setNum');
  }
}

Future<String> getUserToken(Dio dio) async {
  final response = await dio.post(
      'https://rebrickable.com/api/v3/users/_token/',
      data: 'username=${env['USERNAME']}&password=${env['PASSWORD']}',
      options: Options(headers: {
        Headers.contentTypeHeader: Headers.formUrlEncodedContentType
      }));
  return response.data['user_token'];
}

Future<List<String>> getAllSetsNum(Dio dio, String userToken) async {
  final response = await dio.get(
      'https://rebrickable.com/api/v3/users/$userToken/setlists',
      queryParameters: {'page_size': 1000});

  final List<int> setListIds =
      List<int>.from(response.data['results'].map((result) => result['id']));

  List<String> allSets = [];
  for (final setListId in setListIds) {
    final response = await dio.get(
        'https://rebrickable.com/api/v3/users/$userToken/setlists/$setListId/sets/');
    final List<String> setsFromList = List<String>.from(
        response.data['results'].map((result) => result['set']['set_num']));
    allSets.addAll(setsFromList);
  }
  return allSets;
}

downloadMocHtmls(Dio dio, String setNum) async {
  try {
    final response = await dio.get(
      'https://rebrickable.com/api/v3/lego/sets/$setNum/alternates/',
      queryParameters: {'page_size': 1000},
    );

    final List<String> mocHtmlUrls = List<String>.from(
        response.data['results'].map((result) => result['moc_url']));

    Directory('./$mocHtmlDirName/$setNum/').createSync();
    for (final mocHtmlUrl in mocHtmlUrls) {
      final mocName = mocHtmlUrl.split("/")[4];
      await dio.download(mocHtmlUrl, './$mocHtmlDirName/$setNum/$mocName.html');
      await Future.delayed(Duration(milliseconds: 500));
    }
  } on DioError catch (e) {
    log('Failed to download html for $setNum. Error: ${e.message}');
  }
}

downloadPdfs(Dio dio, Directory dir) async {
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
    await downloadPdf(dio, element, setName, mocName);
  }
}

downloadPdf(Dio dio, Element? element, String setNum, String mocName) async {
  if (element != null) {
    String pdfUrlString =
        element.attributes['href']!.replaceFirst('/external/view/?url=', '');
    if (pdfUrlString.contains('&')) {
      pdfUrlString = pdfUrlString.substring(0, pdfUrlString.indexOf('&'));
    }
    final String pdfUrl = Uri.decodeFull(pdfUrlString);
    try {
      final String pdfFileName = './$mocPdfDirName/$setNum/$mocName.pdf';
      await dio.download(pdfUrl, pdfFileName);
      log('Pdf file for $mocName downloaded successful');
    } on DioError catch (e) {
      log('Error fetching pdf for $mocName. Error: ${e.message}');
    }
  } else {
    log('Link not found in $mocName');
  }
}
