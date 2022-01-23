import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:brick_app/infrastructure/service/http_utils.dart';
import 'package:brick_app/infrastructure/service/rebrickable_api_constants.dart';
import 'package:brick_app/infrastructure/service/rebrickable_api_exception.dart';
import 'package:brick_app/model/brick_set.dart';
import 'package:brick_app/model/brick_set_list.dart';
import 'package:brick_app/model/inventory.dart';
import 'package:brick_app/model/moc.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';

class RebrickableService {
  late Client _client;
  String _apiKey = '';
  String _userToken = '';

  set apiKey(String apiKey) => _apiKey = apiKey;
  set userToken(String userToken) => _userToken = userToken;

  bool get isAuthenticated => _userToken.isNotEmpty;

  RebrickableService({Client? client}) {
    _client = client ?? Client();
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

  Future<List<BrickSet>> getSetsFromList({required int listId}) async {
    final userSetListDetailsUrl = Uri.parse(userSetListDetailsUrlTemplate
        .expand({'user_token': _userToken, 'list_id': listId}));
    var results = await getPaginated(_client, userSetListDetailsUrl,
        headers: createHeader());

    return results
        .map((json) => BrickSet.fromJson(json['set']))
        .toList(growable: false);
  }

  Future<List<Moc>> getMocsFromSet({required String setNum}) async {
    final mocsUrl =
        Uri.parse(setMocListUrlTemplate.expand({'set_num': setNum}));
    var results = await getPaginated(_client, mocsUrl, headers: createHeader());

    return results.map((json) => Moc.fromJson(json)).toList(growable: false);
  }

  Future<List<Inventory>> getInventoriesOfSet({required String setNum}) async {
    final mocsUrl =
        Uri.parse(setPartListUrlTemplate.expand({'set_num': setNum}));
    var results = await getPaginated(_client, mocsUrl, headers: createHeader());

    return results
        .map((json) => Inventory.fromJson(json))
        .toList(growable: false);
  }

  Future<String> getMocInstructionUrl({required Moc moc}) async {
    var response = await _client.get(Uri.parse(moc.url));
    var document = parse(response.body);
    final selectors = document.querySelectorAll('div > a');

    final pdfUrl =
        selectors.firstWhere((element) => element.text.contains('.pdf'));
    return 'https://rebrickable.com${pdfUrl.attributes["href"]}';
  }

  Future<List<BrickSetList>> getUsersSetList({int? listId}) async {
    final userSetListUrl = Uri.parse(userSetListUrlTemplate
        .expand({'user_token': _userToken, 'list_id': listId}));
    var results =
        await getPaginated(_client, userSetListUrl, headers: createHeader());

    return results
        .map((json) => BrickSetList.fromJson(json))
        .toList(growable: false);
  }

  Future<void> addSetList({required String setListName}) async {
    final addSetUrl =
        Uri.parse(addSetListUrlTemplate.expand({'user_token': _userToken}));
    var result = await _client.post(addSetUrl,
        headers: createHeader(contentType: 'application/x-www-form-urlencoded'),
        body: 'is_buildable=true&name=$setListName&num_sets=0');
    if (result.statusCode != 201) {
      throw RebrickableApiException(result.statusCode);
    }
  }

  Future<void> deleteSetList({required int setListId}) async {
    final deleteSetUrl = Uri.parse(deleteSetListUrlTemplate
        .expand({'user_token': _userToken, 'list_id': setListId}));
    var result = await _client.delete(deleteSetUrl, headers: createHeader());
    if (result.statusCode != 204) {
      throw RebrickableApiException(result.statusCode);
    }
  }

  Future<void> addSetToList(
      {required int setListId, required String setId}) async {
    final addSetUrl = Uri.parse(addSetToListUrlTemplate
        .expand({'user_token': _userToken, 'list_id': setListId}));
    var result = await _client.post(addSetUrl,
        headers: createHeader(contentType: 'application/x-www-form-urlencoded'),
        body: 'include_spares=true&set_num=$setId&quantity=1');
    if (result.statusCode != 201) {
      throw RebrickableApiException(result.statusCode);
    }
  }

  Future<void> deleteSetFromList(
      {required int setListId, required String setId}) async {
    final deleteSetUrl = Uri.parse(deleteSetFromListUrlTemplate.expand(
        {'user_token': _userToken, 'list_id': setListId, 'set_num': setId}));
    var result = await _client.delete(deleteSetUrl, headers: createHeader());
    if (result.statusCode != 204) {
      throw RebrickableApiException(result.statusCode);
    }
  }

  Map<String, String> createHeader({String? contentType}) {
    if (contentType != null) {
      return {'Authorization': 'key $_apiKey', 'content-type': contentType};
    } else {
      return {'Authorization': 'key $_apiKey'};
    }
  }
}
