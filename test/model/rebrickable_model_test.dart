import 'package:brick_app/model/brick_set.dart';
import 'package:brick_app/model/brick_set_list.dart';
import 'package:brick_app/model/inventory.dart';
import 'package:brick_app/model/moc.dart';
import 'package:brick_app/model/rebrickable_model.dart';
import 'package:brick_app/service/rebrickable_api_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks.dart';
import 'inventory_test.dart';

const userToken = 'myUserToken';

main() {
  group('login', () {
    test('login successfully', () async {
      final serviceMock = MockRebrickableService();
      final model = RebrickableModel(rebrickableService: serviceMock);
      when(() => serviceMock.authenticate('username', 'password'))
          .thenAnswer((_) async => userToken);

      expect(await model.login('username', 'password', 'apiKey'), userToken);
    });

    test('login failed', () async {
      final serviceMock = MockRebrickableService();
      final model = RebrickableModel(rebrickableService: serviceMock);
      when(() => serviceMock.authenticate('username', 'password'))
          .thenThrow(RebrickableApiException('message'));

      expect(model.login('username', 'password', 'apiKey'),
          throwsA(isA<RebrickableApiException>()));
    });
  });

  group('getUsersSetList', () {
    test('all set lists retrieval', () async {
      final setList = BrickSetList.fromJson({
        "id": 521857,
        "is_buildable": true,
        "name": "Set List",
        "num_sets": 23
      });
      final serviceMock = MockRebrickableService();
      final model = RebrickableModel(rebrickableService: serviceMock);
      when(() => serviceMock.getUsersSetList())
          .thenAnswer((_) async => [setList]);

      expect(await model.getUsersSetLists(), [setList]);
    });

    test('single set lists retrieval', () async {
      final setList = BrickSetList.fromJson({
        "id": 521857,
        "is_buildable": true,
        "name": "Set List",
        "num_sets": 23
      });
      final serviceMock = MockRebrickableService();
      final model = RebrickableModel(rebrickableService: serviceMock);
      when(() => serviceMock.getUsersSetList(listId: 521857))
          .thenAnswer((_) async => [setList]);

      expect(await model.getUsersSetLists(listId: 521857), [setList]);
    });

    test('set lists retrieval failed', () async {
      final serviceMock = MockRebrickableService();
      final model = RebrickableModel(rebrickableService: serviceMock);
      when(() => serviceMock.getUsersSetList(listId: 521857))
          .thenThrow(RebrickableApiException('message'));

      expect(model.getUsersSetLists(listId: 521857),
          throwsA(isA<RebrickableApiException>()));
    });
  });

  group('add/delete list', () {
    test('create a new list succeeds', () async {
      final serviceMock = MockRebrickableService();
      final model = RebrickableModel(rebrickableService: serviceMock);
      when(() => serviceMock.addSetList(setListName: 'setListName'))
          .thenAnswer((_) => Future.value());

      await model.addSetList(setListName: 'setListName');
    });

    test('create a new list failed', () async {
      final serviceMock = MockRebrickableService();
      final model = RebrickableModel(rebrickableService: serviceMock);
      when(() => serviceMock.addSetList(setListName: 'setListName'))
          .thenThrow(RebrickableApiException('message'));

      expect(model.addSetList(setListName: 'setListName'),
          throwsA(isA<RebrickableApiException>()));
    });

    test('deleting a list succeeds', () async {
      final serviceMock = MockRebrickableService();
      final model = RebrickableModel(rebrickableService: serviceMock);
      when(() => serviceMock.deleteSetList(setListId: 1))
          .thenAnswer((_) => Future.value());

      await model.deleteSetList(setListId: 1);
    });

    test('deleting a list failed', () async {
      final serviceMock = MockRebrickableService();
      final model = RebrickableModel(rebrickableService: serviceMock);
      when(() => serviceMock.deleteSetList(setListId: 1))
          .thenThrow(RebrickableApiException('message'));

      expect(model.deleteSetList(setListId: 1),
          throwsA(isA<RebrickableApiException>()));
    });
  });

  group('getSetsFromList', () {
    test('all sets retrieval', () async {
      final set = BrickSet.fromJson({
        "set_num": "70672-1",
        "name": "Cole's Dirt Bike",
        "year": 2019,
        "theme_id": 435,
        "num_parts": 221,
        "set_img_url":
            "https://cdn.rebrickable.com/media/sets/70672-1/12578.jpg",
        "set_url": "https://rebrickable.com/sets/70672-1/coles-dirt-bike/",
        "last_modified_dt": "2019-04-19T17:19:54.565420Z"
      });
      final serviceMock = MockRebrickableService();
      final model = RebrickableModel(rebrickableService: serviceMock);
      when(() => serviceMock.getSetsFromList(listId: 548040))
          .thenAnswer((_) async => [set]);

      expect(await model.getSetsFromList(listId: 548040), [set]);
    });

    test('all sets retrieval failed', () async {
      final serviceMock = MockRebrickableService();
      final model = RebrickableModel(rebrickableService: serviceMock);
      when(() => serviceMock.getSetsFromList(listId: 548040))
          .thenThrow(RebrickableApiException('message'));

      expect(model.getSetsFromList(listId: 548040),
          throwsA(isA<RebrickableApiException>()));
    });
  });

  group('getMocsFromSet', () {
    test('all mocs retrieval', () async {
      const String setNum = "MOC-56901";
      final moc = Moc.fromJson(
        {
          "set_num": "MOC-56901",
          "name": "cole's desert car",
          "year": 2020,
          "theme_id": 435,
          "num_parts": 165,
          "moc_img_url": "https://cdn.rebrickable.com/media/mocs/moc-56901.jpg",
          "moc_url":
              "https://rebrickable.com/mocs/MOC-56901/trainsrkool176/coles-desert-car/",
          "designer_name": "trainsrkool176",
          "designer_url": "https://rebrickable.com/users/trainsrkool176/mocs/"
        },
      );
      final serviceMock = MockRebrickableService();
      final model = RebrickableModel(rebrickableService: serviceMock);
      when(() => serviceMock.getMocsFromSet(setNum: setNum))
          .thenAnswer((_) async => [moc]);

      expect(await model.getMocsFromSet(setNum: setNum), [moc]);
    });

    test('all mocs retrieval failed', () async {
      const String setNum = "MOC-56901";
      final serviceMock = MockRebrickableService();
      final model = RebrickableModel(rebrickableService: serviceMock);
      when(() => serviceMock.getMocsFromSet(setNum: setNum))
          .thenThrow(RebrickableApiException('message'));

      expect(model.getMocsFromSet(setNum: setNum),
          throwsA(isA<RebrickableApiException>()));
    });
  });

  group('getInventoriesOfSet', () {
    test('succeeds', () async {
      const String setNum = "70672-1";
      final Inventory inventory = Inventory.fromJson(inventoryJson);
      final serviceMock = MockRebrickableService();
      final model = RebrickableModel(rebrickableService: serviceMock);
      when(() => serviceMock.getInventoriesOfSet(setNum: setNum))
          .thenAnswer((_) async => [inventory]);

      expect(await model.getInventoriesOfSet(setNum: setNum), [inventory]);
    });

    test('fails', () async {
      const String setNum = "70672-1";
      final serviceMock = MockRebrickableService();
      final model = RebrickableModel(rebrickableService: serviceMock);
      when(() => serviceMock.getInventoriesOfSet(setNum: setNum))
          .thenThrow(RebrickableApiException('message'));

      expect(model.getInventoriesOfSet(setNum: setNum),
          throwsA(isA<RebrickableApiException>()));
    });
  });
}
