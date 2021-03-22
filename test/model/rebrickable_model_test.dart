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

      expect(await model.login('username', 'password'), true);
    });
    test('login failed', () async {
      final serviceMock = RebrickableServiceMock();
      final model = RebrickableModel(rebrickableService: serviceMock);
      when(serviceMock.authenticate('username', 'password'))
          .thenAnswer((_) async => false);

      expect(await model.login('username', 'password'), false);
    });
  });
}
