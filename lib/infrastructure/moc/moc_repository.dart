import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:brick_app/core/failure.dart';
import 'package:brick_app/credentials/api_gateway.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

abstract class MocRepositoryFacade {
  Future<List<String>> areBuildInstructionsAvailable(
      {required String setNum, required List<String> mocNums});

  Future<Either<Failure, File>> getBuildInstruction(
      {required String setNum, required String mocNum});

  Future<Either<Failure, Uri>> getBuildInstructionUrl(
      {required String setNum, required String mocNum});
}

@Injectable(as: MocRepositoryFacade)
class MocRepository implements MocRepositoryFacade {
  @override
  Future<List<String>> areBuildInstructionsAvailable(
      {required String setNum, required List<String> mocNums}) async {
    final urlPath = '$apiGwBaseUrl/sets/$setNum';

    final response =
        await get(Uri.parse(urlPath), headers: {'x-api-key': apiGwKey});
    if (response.statusCode != 200) {
      final errMsg = 'Could not request moc list for $setNum';
      log(errMsg);
    }

    final List<String> mocNameKeys = jsonDecode(response.body)['Contents']
        .map((content) => content['Key'])
        .cast<String>()
        .toList();

    final List<String> mocNames = mocNameKeys
        .map((mocNameKey) =>
            mocNameKey.replaceFirst('$setNum/', '').replaceFirst('.pdf', ''))
        .toList();

    return List<String>.from(
        mocNames.where((mocName) => mocNums.contains(mocName)));
  }

  @override
  Future<Either<Failure, File>> getBuildInstruction(
      {required String setNum, required String mocNum}) async {
    final response =
        await getBuildInstructionUrl(setNum: setNum, mocNum: mocNum);

    return response.fold((failure) {
      return left(failure);
    }, (presignedUrl) async {
      final appDir = await getApplicationDocumentsDirectory();
      final File pdf = File('${appDir.path}/$setNum/$mocNum.pdf')
        ..createSync(recursive: true);

      await get(presignedUrl).then((r) {
        pdf.writeAsBytesSync(r.bodyBytes);
      });

      return right(pdf);
    });
  }

  @override
  Future<Either<Failure, Uri>> getBuildInstructionUrl(
      {required String setNum, required String mocNum}) async {
    final urlPath = '$apiGwBaseUrl/sets/$setNum/mocs/$mocNum';
    final response =
        await get(Uri.parse(urlPath), headers: {'x-api-key': apiGwKey});
    if (response.statusCode != 200) {
      final String errMsg =
          'Failed to get presigned url to build instructions for set $setNum and moc $mocNum from $urlPath. ErrorCode ${response.statusCode}';
      log(errMsg);
      return left(Failure(errMsg));
    }
    return right(Uri.parse(response.body.replaceAll('"', '')));
  }
}
