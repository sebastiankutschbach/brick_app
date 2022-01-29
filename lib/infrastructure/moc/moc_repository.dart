import 'dart:developer';
import 'dart:typed_data';
import 'package:brick_app/core/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart';

abstract class MocRepositoryFacade {
  Future<List<String>> areBuildInstructionsAvailable(
      {required String setNum, required List<String> mocNums});

  Future<Either<Failure, Uint8List>> getBuildInstruction(
      {required String setNum, required String mocNum});
}

class MocRepository implements MocRepositoryFacade {
  @override
  Future<Either<Failure, Uint8List>> getBuildInstruction(
      {required String setNum, required String mocNum}) async {
    final urlPath = 'https://brickapp.sebku.de/mocs/$setNum/$mocNum.pdf';
    print(urlPath);
    final response = await get(Uri.parse(urlPath));
    if (response.statusCode != 200) {
      final String errMsg =
          'Failed to download build instructions for set $setNum and moc $mocNum from $urlPath. ErrorCode ${response.statusCode}';
      log(errMsg);
      return left(Failure(errMsg));
    }

    return right(response.bodyBytes);
  }

  @override
  Future<List<String>> areBuildInstructionsAvailable(
      {required String setNum, required List<String> mocNums}) async {
    final results = <String>[];
    for (final mocNum in mocNums) {
      final urlPath = 'https://brickapp.sebku.de/mocs/$setNum/$mocNum.pdf';
      final response = await head(Uri.parse(urlPath));

      if (response.statusCode == 200) {
        results.add(mocNum);
      }
    }
    return results;
  }
}
