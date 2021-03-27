import 'package:uri/uri.dart';

const String authority = 'rebrickable.com';

const String _baseUrl = '/api/v3';
const String _userApi = '/users';

Uri userTokenUrl = Uri.https(authority, '$_baseUrl$_userApi/_token/');
UriTemplate userSetListUrlTemplate = UriTemplate(
    'https://$authority$_baseUrl$_userApi/{user_token}/setlists/{list_id}');

UriTemplate userSetListDetailsUrlTemplate = UriTemplate(
    'https://$authority$_baseUrl$_userApi/{user_token}/setlists/{list_id}/sets/');
