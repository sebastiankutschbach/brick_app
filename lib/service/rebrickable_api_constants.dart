import 'package:uri/uri.dart';

const String authority = 'rebrickable.com';

const String _baseUrl = '/api/v3';
const String _userApi = '/users';
const String _setsApi = '/sets';

Uri userTokenUrl = Uri.https(authority, '$_baseUrl$_userApi/_token/');
UriTemplate userSetListUrlTemplate = UriTemplate(
    'https://$authority$_baseUrl$_userApi/{user_token}/setlists/{list_id}');

UriTemplate userSetListDetailsUrlTemplate = UriTemplate(
    'https://$authority$_baseUrl$_userApi/{user_token}/setlists/{list_id}/sets/');

UriTemplate setMocListUrlTemplate =
    UriTemplate('https://$authority$_baseUrl$_setsApi/{set_num}/alternates');
