import 'dart:io';
import 'dart:math';

import 'package:brick_app/infrastructure/moc/moc_repository.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  test('downloads an existing moc build instruction', () async {
    final MocRepositoryFacade mocRepository = MocRepository();

    final response = await mocRepository.getBuildInstruction(
        setNum: '10696-1', mocNum: 'MOC-93758');

    response.fold((failure) => fail('Should not throw an error'),
        (downloadedFile) async {
      expect(await downloadedFile.exists(), true);
      downloadedFile.deleteSync();
    });
  });

  test('returns failure when requesting an non-existing moc build instruction',
      () async {
    final MocRepositoryFacade mocRepository = MocRepository();

    final response = await mocRepository.getBuildInstruction(
        setNum: 'doesnotexist-1', mocNum: 'doesnotexist-93758');

    response.fold((failure) => expect(failure, isNotNull),
        (downloadedFile) => fail('Should have thrown an error instead'));
  });
}
