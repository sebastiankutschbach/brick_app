import 'package:brick_app/model/brick_set.dart';
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
  RebrickableService service;

  void _setUpAuthenticatedServiceMock() async {
    client = MockClient();
    service = RebrickableService('apiKey', client: client);
    when(client.post(userTokenUrl,
            headers: _authHeaderWithContentType,
            body: 'username=username&password=password'))
        .thenAnswer((_) async => Response('{"user_token": "validtoken"}', 200));

    await service.authenticate('username', 'password');
  }

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
      _setUpAuthenticatedServiceMock();
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

    test('it should retrieve a specific set list', () async {
      final id = 521857;
      final uri = Uri.parse(userSetListUrlTemplate
          .expand({'user_token': 'validtoken', 'list_id': id}));
      when(client.get(uri, headers: _authHeader))
          .thenAnswer((_) async => Response('''{
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

      expect((await service.getUsersSetList(listId: 521857)).first.id, 521857);
    });
  });

  group('set list details', () {
    setUp(() async {
      _setUpAuthenticatedServiceMock();
    });

    test('it should retrieve a specific set', () async {
      final id = 548040;
      final uri = Uri.parse(userSetListDetailsUrlTemplate
          .expand({'user_token': 'validtoken', 'list_id': id}));
      when(client.get(uri, headers: _authHeader))
          .thenAnswer((_) async => Response('''{
          "count": 1,
          "next": null,
          "previous": null,
          "results": [
            {
              "list_id": 548040,
              "quantity": 1,
              "include_spares": true,
              "set": {
                "set_num": "70672-1",
                "name": "Cole's Dirt Bike",
                "year": 2019,
                "theme_id": 435,
                "num_parts": 221,
                "set_img_url": "https://cdn.rebrickable.com/media/sets/70672-1/12578.jpg",
                "set_url": "https://rebrickable.com/sets/70672-1/coles-dirt-bike/",
                "last_modified_dt": "2019-04-19T17:19:54.565420Z"
              }
            }
          ]
        }''', 200));

      final List<BrickSet> brickSets =
          await service.getSetsFromList(listId: 548040);

      expect(brickSets.length, 1);
    });

    test('it should handle http errors', () async {
      final id = 548040;
      final uri = Uri.parse(userSetListDetailsUrlTemplate
          .expand({'user_token': 'validtoken', 'list_id': id}));
      when(client.get(uri, headers: _authHeader))
          .thenAnswer((_) async => Response('not found', 404));

      final List<BrickSet> brickSets =
          await service.getSetsFromList(listId: 548040);

      expect(brickSets, isNull);
    });
  });
}
