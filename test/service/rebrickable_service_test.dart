import 'package:brick_app/service/rebrickable_api_constants.dart';
import 'package:brick_app/service/rebrickable_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'rebrickable_service_test.mocks.dart';

@GenerateMocks([Client])
void main() {
  final String _apiKey = 'apiKey';
  final Map<String, String> _authHeader = {'Authorization': 'key $_apiKey'};
  final Map<String, String> _authHeaderWithContentType = {
    'Authorization': 'key $_apiKey',
    'content-type': 'application/x-www-form-urlencoded'
  };
  var client;
  var service;
  group('authentication', () {
    setUp(() {
      client = MockClient();
      service = RebrickableService(_apiKey, client: client);
    });

    test('it should have a token set on successful authentication', () async {
      when(client.post(userTokenUrl,
              headers: _authHeaderWithContentType,
              body: 'username=username&password=password'))
          .thenAnswer(
              (_) async => Response('{"user_token": "validtoken"}', 200));

      expect(await service.authenticate('username', 'password'), isTrue);
      expect(service.isAuthenticated, isTrue);
    });

    test('it should not have a token set on unsuccessful authentication',
        () async {
      when(client.post(userTokenUrl,
              headers: _authHeaderWithContentType,
              body: 'username=invalid&password=invalid'))
          .thenAnswer(
              (_) async => Response('{"detail": "Invalid credentials"}', 403));

      expect(await service.authenticate('invalid', 'invalid'), isFalse);
      expect(service.isAuthenticated, isFalse);
    });
  });

  group('set list', () {
    setUp(() async {
      client = MockClient();
      service = RebrickableService('apiKey', client: client);
      when(client.post(userTokenUrl,
              headers: _authHeaderWithContentType,
              body: 'username=username&password=password'))
          .thenAnswer(
              (_) async => Response('{"user_token": "validtoken"}', 200));

      await service.authenticate('username', 'password');
    });

    test('it should retrieve the users set lists', () async {
      when(client.get(
        Uri.parse(userSetListUrlTemplate.expand({'user_token': 'validtoken'})),
        headers: _authHeader,
      )).thenAnswer((_) async => Response('''{
        "count": 1,
        "next": null,
        "previous": null,
        "results": [
          {
            "id": 521857,
            "is_buildable": true,
            "name": "Set List",
            "num_sets": 23
          }
        ]
      }''', 200));

      expect((await service.getUsersSetList()).length, 1);
    });

    test('it should retrieve a specific set', () async {
      final id = 521857;
      final uri = Uri.parse(userSetListUrlTemplate
          .expand({'user_token': 'validtoken', 'list_id': id}));
      when(client.get(uri, headers: _authHeader))
          .thenAnswer((_) async => Response('''
          {
            "id": 521857,
            "is_buildable": true,
            "name": "Set List",
            "num_sets": 23
      }''', 200));

      expect((await service.getUsersSetList(setId: 521857)).first.id, 521857);
    });
  });
}
