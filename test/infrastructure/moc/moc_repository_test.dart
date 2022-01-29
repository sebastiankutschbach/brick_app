import 'dart:io';
import 'dart:math';

import 'package:brick_app/infrastructure/moc/moc_repository.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  late MocRepositoryFacade mocRepository;

  setUp(() {
    mocRepository = MocRepository();
  });

  group('get build instructions', () {
    test('downloads an existing moc build instruction', () async {
      final response = await mocRepository.getBuildInstruction(
          setNum: '10696-1', mocNum: 'MOC-93758');

      response.fold((failure) => fail('Should not throw an error'),
          (downloadedBytes) async {
        expect(downloadedBytes.length, greaterThan(0));
      });
    });

    test(
        'returns failure when requesting an non-existing moc build instruction',
        () async {
      final response = await mocRepository.getBuildInstruction(
          setNum: 'doesnotexist-1', mocNum: 'doesnotexist-93758');

      response.fold((failure) => expect(failure, isNotNull),
          (downloadedFile) => fail('Should have thrown an error instead'));
    });
  });

  group('are build instructions available', () {
    test('only returns moc nums for which are build instructions available',
        () async {
      expect(
          await mocRepository.areBuildInstructionsAvailable(
              setNum: '10696-1', mocNums: ['MOC-93758', 'MOC-12345']),
          ['MOC-93758']);
    });

    test('returns empty list for set without mocs', () async {
      expect(
        await mocRepository.areBuildInstructionsAvailable(
            setNum: '854-1', mocNums: ['MOC-93758', 'MOC-12345']),
        [],
      );
    });

    test('returns empty list for non existing set num', () async {
      expect(
        await mocRepository.areBuildInstructionsAvailable(
            setNum: '11111-1', mocNums: ['MOC-93758', 'MOC-12345']),
        [],
      );
    });
  });
}
