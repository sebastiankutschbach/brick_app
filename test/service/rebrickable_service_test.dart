import 'package:brick_app/model/brick_set.dart';
import 'package:brick_app/model/inventory.dart';
import 'package:brick_app/model/moc.dart';
import 'package:brick_app/service/http_utils.dart';
import 'package:brick_app/service/rebrickable_api_constants.dart';
import 'package:brick_app/service/rebrickable_api_exception.dart';
import 'package:brick_app/service/rebrickable_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks.dart';

void main() {
  final String _apiKey = 'apiKey';
  final Map<String, String> _authHeader = {'Authorization': 'key $_apiKey'};
  final Map<String, String> _authHeaderWithContentType = {
    'Authorization': 'key $_apiKey',
    'content-type': 'application/x-www-form-urlencoded'
  };
  var client;
  late RebrickableService service;

  void _setUpAuthenticatedServiceMock() async {
    httpCache.clear();
    client = MockClient();
    service = RebrickableService(client: client);
    service.apiKey = 'apiKey';
    when(() => client.post(userTokenUrl,
            headers: _authHeaderWithContentType,
            body: 'username=username&password=password'))
        .thenAnswer((_) async => Response('{"user_token": "validtoken"}', 200));

    await service.authenticate('username', 'password');
  }

  group('authentication', () {
    setUp(() {
      client = MockClient();
      service = RebrickableService(client: client);
      service.apiKey = 'apiKey';
    });

    test('it should have a token set on successful authentication', () async {
      when(() => client.post(userTokenUrl,
              headers: _authHeaderWithContentType,
              body: 'username=username&password=password'))
          .thenAnswer(
              (_) async => Response('{"user_token": "validtoken"}', 200));

      expect(await service.authenticate('username', 'password'), isNotEmpty);
      expect(service.isAuthenticated, isTrue);
    });

    test('it should not have a token set on unsuccessful authentication',
        () async {
      when(() => client.post(userTokenUrl,
              headers: _authHeaderWithContentType,
              body: 'username=invalid&password=invalid'))
          .thenAnswer(
              (_) async => Response('{"detail": "Invalid credentials"}', 403));

      expect(service.authenticate('invalid', 'invalid'),
          throwsA(isA<RebrickableApiException>()));
      expect(service.isAuthenticated, isFalse);
    });
  });

  group('set list', () {
    setUp(() async {
      _setUpAuthenticatedServiceMock();
    });

    test('it should retrieve the users set lists', () async {
      when(() => client.get(
            Uri.parse(
                userSetListUrlTemplate.expand({'user_token': 'validtoken'})),
            headers: _authHeader,
          )).thenAnswer((_) async => Response(aSetListList, 200));

      expect((await service.getUsersSetList()).length, 1);
    });

    test('it should retrieve a specific set list', () async {
      final id = 521857;
      final uri = Uri.parse(userSetListUrlTemplate
          .expand({'user_token': 'validtoken', 'list_id': id}));
      when(() => client.get(uri, headers: _authHeader))
          .thenAnswer((_) async => Response(aSingleSetListList, 200));

      expect((await service.getUsersSetList(listId: 521857)).first.id, 521857);
    });
  });

  group('add set list', () {
    setUp(() async {
      _setUpAuthenticatedServiceMock();
    });

    test('executes fine', () async {
      final setListName = 'setListName';
      final url =
          Uri.parse(addSetListUrlTemplate.expand({'user_token': 'validtoken'}));
      final body = 'is_buildable=true&name=$setListName&num_sets=0';
      final headers = _authHeaderWithContentType;
      when(() => client.post(url, headers: headers, body: body))
          .thenAnswer((_) async => Response('', 200));

      await service.addSetList(setListName: setListName);
      verify(() => client.post(url, headers: headers, body: body)).called(1);
    });

    test('handles error', () async {
      final setListName = 'setListName';
      final url =
          Uri.parse(addSetListUrlTemplate.expand({'user_token': 'validtoken'}));
      final body = 'is_buildable=true&name=$setListName&num_sets=0';
      final headers = _authHeaderWithContentType;
      when(() => client.post(url, headers: headers, body: body))
          .thenAnswer((_) async => Response('', 500));

      expect(() async => await service.addSetList(setListName: setListName),
          throwsA(isA<RebrickableApiException>()));
      verify(() => client.post(url, headers: headers, body: body)).called(1);
    });
  });

  group('delete set list', () {
    setUp(() async {
      _setUpAuthenticatedServiceMock();
    });

    test('executes fine', () async {
      final setListId = 1;
      final url = Uri.parse(deleteSetListUrlTemplate
          .expand({'user_token': 'validtoken', 'list_id': setListId}));
      final headers = _authHeader;
      when(() => client.delete(url, headers: headers))
          .thenAnswer((_) async => Response('', 200));

      await service.deleteSetList(setListId: setListId);

      verify(() => client.delete(url, headers: headers)).called(1);
    });

    test('handles error', () async {
      final setListId = 1;
      final url = Uri.parse(deleteSetListUrlTemplate
          .expand({'user_token': 'validtoken', 'list_id': setListId}));
      final headers = _authHeader;
      when(() => client.delete(url, headers: headers))
          .thenAnswer((_) async => Response('', 404));

      expect(() async => await service.deleteSetList(setListId: setListId),
          throwsA(isA<RebrickableApiException>()));

      verify(() => client.delete(url, headers: headers)).called(1);
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
      when(() => client.get(uri, headers: _authHeader))
          .thenAnswer((_) async => Response(aSingleSet, 200));

      final List<BrickSet> brickSets =
          await service.getSetsFromList(listId: 548040);

      expect(brickSets.length, 1);
    });

    test('it should handle http errors', () async {
      final id = 548040;
      final uri = Uri.parse(userSetListDetailsUrlTemplate
          .expand({'user_token': 'validtoken', 'list_id': id}));
      when(() => client.get(uri, headers: _authHeader))
          .thenAnswer((_) async => Response('not found', 404));

      expect(service.getSetsFromList(listId: 548040),
          throwsA(isA<RebrickableApiException>()));
    });
  });

  group('mocs for set', () {
    setUp(() async {
      _setUpAuthenticatedServiceMock();
    });

    test('it should retrieve mocs for a set', () async {
      final setNum = "70672-1";
      final uri = Uri.parse(setMocListUrlTemplate.expand({'set_num': setNum}));
      when(() => client.get(uri, headers: _authHeader))
          .thenAnswer((_) async => Response(aMocList, 200));

      final List<Moc> mocs = await service.getMocsFromSet(setNum: setNum);

      expect(mocs.length, 2);
    });

    test('it should handle http errors', () async {
      final setNum = "70672-1";
      final uri = Uri.parse(setMocListUrlTemplate.expand({'set_num': setNum}));
      when(() => client.get(uri, headers: _authHeader))
          .thenAnswer((_) async => Response('not found', 404));

      expect(service.getMocsFromSet(setNum: setNum),
          throwsA(isA<RebrickableApiException>()));
    });
  });

  group('inventories of set', () {
    setUp(() async {
      _setUpAuthenticatedServiceMock();
    });

    test('it should retrieve inventories for a set', () async {
      final setNum = "70672-1";
      final uri = Uri.parse(setPartListUrlTemplate.expand({'set_num': setNum}));
      when(() => client.get(uri, headers: _authHeader))
          .thenAnswer((_) async => Response(anInventoryList, 200));

      final List<Inventory> inventories =
          await service.getInventoriesOfSet(setNum: setNum);

      expect(inventories.length, 1);
    });

    test('it should handle http errors', () async {
      final setNum = "70672-1";
      final uri = Uri.parse(setPartListUrlTemplate.expand({'set_num': setNum}));
      when(() => client.get(uri, headers: _authHeader))
          .thenAnswer((_) async => Response('not found', 404));

      expect(service.getInventoriesOfSet(setNum: setNum),
          throwsA(isA<RebrickableApiException>()));
    });
  });

  group('moc instructions', () {
    setUp(() async {
      _setUpAuthenticatedServiceMock();
    });

    test('it should retrieve pdf url for a moc', () async {
      final moc = MockMoc();
      final mocUrl = Uri.parse('https://myawesome.mock');
      final html = await get(Uri.parse(
          'https://rebrickable.com/mocs/MOC-22588/LegoMechable/70652-storm-dragon-mech/#details'));
      when(() => moc.url).thenReturn(mocUrl.toString());
      when(() => client.get(mocUrl)).thenAnswer((_) async => html);

      final mocInstructionUrl = await service.getMocInstructionUrl(moc: moc);

      expect(
          mocInstructionUrl,
          startsWith(
              'https://rebrickable.com/users/Rebrickable/mocs/purchases/download/'));
    });
  });
}

final aSetListList = '''{
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
      }''';

final aSingleSetListList = '''{
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
        }''';

final aSingleSet = '''{
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
        }''';

final aMocList = '''{
          "count": 2,
          "next": null,
          "previous": null,
          "results": [
            {
              "set_num": "MOC-56901",
              "name": "cole's desert car",
              "year": 2020,
              "theme_id": 435,
              "num_parts": 165,
              "moc_img_url": "https://cdn.rebrickable.com/media/mocs/moc-56901.jpg",
              "moc_url": "https://rebrickable.com/mocs/MOC-56901/trainsrkool176/coles-desert-car/",
              "designer_name": "trainsrkool176",
              "designer_url": "https://rebrickable.com/users/trainsrkool176/mocs/"
            },
            {
              "set_num": "MOC-69836",
              "name": "Cole´s Stone Bike",
              "year": 2021,
              "theme_id": 435,
              "num_parts": 195,
              "moc_img_url": "https://cdn.rebrickable.com/media/mocs/moc-69836.jpg",
              "moc_url": "https://rebrickable.com/mocs/MOC-69836/dorianbricktron/cole-s-stone-bike/",
              "designer_name": "dorianbricktron",
              "designer_url": "https://rebrickable.com/users/dorianbricktron/mocs/"
            }
          ]
        }''';

final anInventoryList = '''{
            "count": 2,
            "next": null,
            "previous": null,
            "results": [
              {
                "id": 173266,
                "inv_part_id": 173266,
                "part": {
                  "part_num": "3941",
                  "name": "Brick Round 2 x 2 with Axle Hole",
                  "part_cat_id": 20,
                  "part_url":
                      "https://rebrickable.com/parts/3941/brick-round-2-x-2-with-axle-hole/",
                  "part_img_url":
                      "https://cdn.rebrickable.com/media/parts/elements/614326.jpg",
                  "external_ids": {
                    "BrickOwl": ["997602"],
                    "LDraw": ["3941", "6143"],
                    "LEGO": ["39223", "6116", "6143"]
                  },
                  "print_of": null
                },
                "color": {
                  "id": 0,
                  "name": "Black",
                  "rgb": "05131D",
                  "is_trans": false,
                  "external_ids": {
                    "BrickLink": {
                      "ext_ids": [11],
                      "ext_descrs": [
                        ["Black"]
                      ]
                    },
                    "BrickOwl": {
                      "ext_ids": [38],
                      "ext_descrs": [
                        ["Black"]
                      ]
                    },
                    "LEGO": {
                      "ext_ids": [26, 149, 1012],
                      "ext_descrs": [
                        ["Black", "BLACK"],
                        ["Metallic Black", "MET.BLACK"],
                        ["CONDUCT. BLACK"]
                      ]
                    },
                    "Peeron": {
                      "ext_ids": [null],
                      "ext_descrs": [
                        ["black"]
                      ]
                    },
                    "LDraw": {
                      "ext_ids": [0, 256],
                      "ext_descrs": [
                        ["Black"],
                        ["Rubber_Black"]
                      ]
                    }
                  }
                },
                "set_num": "8063-1",
                "quantity": 3,
                "is_spare": false,
                "element_id": "614326",
                "num_sets": 364
              }
            ]
          }''';
