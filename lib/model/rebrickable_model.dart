import 'package:brick_app/model/brick_set.dart';
import 'package:brick_app/model/brick_set_list.dart';
import 'package:brick_app/model/inventory.dart';
import 'package:brick_app/model/moc.dart';
import 'package:brick_app/service/rebrickable_service.dart';
import 'package:flutter/cupertino.dart';

class RebrickableModel with ChangeNotifier {
  RebrickableService rebrickableService;
  bool _loggedIn = false;
  BrickSet? _selectedBrickSet;

  bool get isLoggedIn => _loggedIn;
  BrickSet? get selectedBrickSet => _selectedBrickSet;

  RebrickableModel({required this.rebrickableService});

  Future<String> login(String username, String password, String apiKey) async {
    rebrickableService.apiKey = apiKey;
    final userToken = await rebrickableService.authenticate(username, password);
    _loggedIn = userToken.isNotEmpty;
    return userToken;
  }

  Future<String> loginWithToken(String userToken, String apiKey) async {
    rebrickableService.apiKey = apiKey;
    rebrickableService.userToken = userToken;
    _loggedIn = true;
    return userToken;
  }

  Future<List<BrickSetList>> getUsersSetLists({int? listId}) async {
    return listId == null
        ? rebrickableService.getUsersSetList()
        : rebrickableService.getUsersSetList(listId: listId);
  }

  Future<List<BrickSet>> getSetsFromList({required int listId}) async {
    return rebrickableService.getSetsFromList(listId: listId);
  }

  Future<List<Moc>> getMocsFromSet({required String setNum}) async {
    return rebrickableService.getMocsFromSet(setNum: setNum);
  }

  Future<List<Inventory>> getInventoriesOfSet({required String setNum}) async {
    return rebrickableService.getInventoriesOfSet(setNum: setNum);
  }

  Future<void> addSetList({required String setListName}) async {
    return rebrickableService.addSetList(setListName: setListName);
  }

  Future<void> deleteSetList({required int setListId}) async {
    return rebrickableService.deleteSetList(setListId: setListId);
  }
}
