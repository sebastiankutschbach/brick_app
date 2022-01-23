import 'dart:convert';
import 'dart:developer';

import 'package:brick_app/infrastructure/service/rebrickable_api_exception.dart';
import 'package:http/http.dart';

Future<List<dynamic>> getPaginated(Client client, Uri url,
    {Map<String, String> headers = const {}}) async {
  var body = await _getJsonDecoded(client, url, headers: headers);
  final List values = body['results'];
  while (body['next'] != null) {
    body = await _getJsonDecoded(client, Uri.parse(body['next']),
        headers: headers);
    values.addAll(body['results']);
  }
  return values;
}

Future<Map> _getJsonDecoded(Client client, Uri url,
    {Map<String, String> headers = const {}}) async {
  final response = await client.get(url, headers: headers);
  _checkStatusCode(response.statusCode, url);
  return jsonDecode(response.body);
}

void _checkStatusCode(int statusCode, Uri url) {
  if (statusCode != 200) {
    log('Error requesting uri $url');
    log('Status code: $statusCode');
    throw RebrickableApiException(statusCode);
  }
}
