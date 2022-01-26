import 'dart:developer';
import 'dart:io';
import 'package:brick_app/core/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

abstract class MocRepositoryFacade {
  Future<Either<Failure, File>> getBuildInstruction(
      {required String setNum, required String mocNum});
}

class MocRepository implements MocRepositoryFacade {
  @override
  Future<Either<Failure, File>> getBuildInstruction(
      {required String setNum, required String mocNum}) async {
    final directory = await getApplicationDocumentsDirectory();

    final urlPath = 'https://brickapp.sebku.de/mocs/$setNum/$mocNum.pdf';
    final response = await get(Uri.parse(urlPath));
    if (response.statusCode != 200) {
      final String errMsg =
          'Failed to download build instructions for set $setNum and moc $mocNum from $urlPath. ErrorCode ${response.statusCode}';
      log(errMsg);
      return left(Failure(errMsg));
    }
    final downloadedFile = File('${directory.path}/$mocNum.pdf')
      ..createSync()
      ..writeAsBytesSync(response.bodyBytes);
    return right(downloadedFile);
  }
}
