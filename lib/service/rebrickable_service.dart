import 'dart:convert';
import 'dart:developer';

import 'package:brick_app/model/brick_set.dart';
import 'package:brick_app/model/brick_set_list.dart';
import 'package:brick_app/model/moc.dart';
import 'package:brick_app/service/http_utils.dart';
import 'package:brick_app/service/rebrickable_api_constants.dart';
import 'package:brick_app/service/rebrickable_api_exception.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'dart:async';

class RebrickableService {
  Client _client;
  String _apiKey;
  String _userToken;

  set apiKey(String apiKey) => _apiKey = apiKey;
  set userToken(String userToken) => _userToken = userToken;

  bool get isAuthenticated => _userToken != null;

  RebrickableService(this._apiKey, {Client client}) {
    this._client = client ?? Client();
  }

  Future<String> authenticate(String username, String password) async {
    final response = await _client.post(userTokenUrl,
        headers: createHeader(contentType: 'application/x-www-form-urlencoded'),
        body: 'username=$username&password=$password');

    if (response.statusCode != 200) {
      log('Error authenticating against rebrickable api');
      log('Status code: ${response.statusCode}');
      throw RebrickableApiException(response.statusCode);
    }

    final body = jsonDecode(response.body);
    _userToken = body['user_token'];
    return _userToken;
  }

  Future<List<BrickSetList>> getUsersSetList({int listId}) async {
    final userSetListUrl = Uri.parse(userSetListUrlTemplate
        .expand({'user_token': _userToken, 'list_id': listId}));
    var results =
        await getPaginated(_client, userSetListUrl, headers: createHeader());

    return results
        .map((json) => BrickSetList.fromJson(json))
        .toList(growable: false);
  }

  Future<List<BrickSet>> getSetsFromList({@required int listId}) async {
    final userSetListDetailsUrl = Uri.parse(userSetListDetailsUrlTemplate
        .expand({'user_token': _userToken, 'list_id': listId}));
    var results = await getPaginated(_client, userSetListDetailsUrl,
        headers: createHeader());

    return results
        .map((json) => BrickSet.fromJson(json['set']))
        .toList(growable: false);
  }

  Future<List<Moc>> getMocsFromSet({@required String setNum}) async {
    final mocsUrl =
        Uri.parse(setMocListUrlTemplate.expand({'set_num': setNum}));
    var results = await getPaginated(_client, mocsUrl, headers: createHeader());

    return results.map((json) => Moc.fromJson(json)).toList(growable: false);
  }

  Map<String, String> createHeader({String contentType}) {
    if (contentType != null) {
      return {'Authorization': 'key $_apiKey', 'content-type': contentType};
    } else {
      return {'Authorization': 'key $_apiKey'};
    }
  }
}
