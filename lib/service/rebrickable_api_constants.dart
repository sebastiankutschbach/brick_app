const String authority = 'rebrickable.com';

const String _baseUrl = '/api/v3';
const String _userApi = '/users';

Uri userTokenUrl = Uri.https(authority, '$_baseUrl$_userApi/_token/');
Uri userSetListUrl = Uri.https(authority, '$_baseUrl$_userApi/setlists/');
