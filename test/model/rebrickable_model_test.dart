import 'package:brick_app/model/brick_set.dart';
import 'package:brick_app/model/rebrickable_model.dart';
import 'package:brick_app/service/rebrickable_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class RebrickableServiceMock extends Mock implements RebrickableService {}

main() {
  group('login', () {
    test('login successfully', () async {
      final serviceMock = RebrickableServiceMock();
      final model = RebrickableModel(rebrickableService: serviceMock);
      when(serviceMock.authenticate('username', 'password'))
          .thenAnswer((_) async => true);

      expect(await model.login('username', 'password', 'apiKey'), true);
    });
    test('login failed', () async {
      final serviceMock = RebrickableServiceMock();
      final model = RebrickableModel(rebrickableService: serviceMock);
      when(serviceMock.authenticate('username', 'password'))
          .thenAnswer((_) async => false);

      expect(await model.login('username', 'password', 'apiKey'), false);
    });
  });

  group('getUsersSetList', () {
    test('set lists retrieval', () async {
      final setList = BrickSet.fromJson({
        "id": 521857,
        "is_buildable": true,
        "name": "Set List",
        "num_sets": 23
      });
      final serviceMock = RebrickableServiceMock();
      final model = RebrickableModel(rebrickableService: serviceMock);
      when(serviceMock.getUsersSetList()).thenAnswer((_) async => [setList]);

      expect(await model.getUsersSetLists(), [setList]);
    });
  });
}
