import 'package:brick_app/model/brick_set.dart';
import 'package:brick_app/model/brick_set_list.dart';
import 'package:brick_app/model/moc.dart';
import 'package:brick_app/service/rebrickable_service.dart';
import 'package:flutter/cupertino.dart';

class RebrickableModel with ChangeNotifier {
  RebrickableService _rebrickableService;
  bool _loggedIn = false;

  bool get isLoggedIn => _loggedIn;

  RebrickableModel({RebrickableService rebrickableService}) {
    this._rebrickableService = rebrickableService ?? RebrickableService('');
  }

  Future<String> login(String username, String password, String apiKey) async {
    _rebrickableService.apiKey = apiKey;
    final userToken =
        await _rebrickableService.authenticate(username, password);
    _loggedIn = userToken != null;
    return userToken;
  }

  Future<List<BrickSetList>> getUsersSetLists({int listId}) async {
    return _rebrickableService.getUsersSetList(listId: listId);
  }

  Future<List<BrickSet>> getSetsFromList({@required int listId}) async {
    return _rebrickableService.getSetsFromList(listId: listId);
  }

  Future<List<Moc>> getMocsFromSet({@required String setNum}) async {
    return _rebrickableService.getMocsFromSet(setNum: setNum);
  }
}
