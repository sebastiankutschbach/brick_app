import 'package:brick_app/service/http_utils.dart';
import 'package:brick_app/service/rebrickable_api_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uri/uri.dart';

import '../mocks.dart';

main() {
  group('pagination', () {
    test('loads next page until "next" field is not null', () async {
      final client = MockClient();
      final urlTemplate = UriTemplate('https://myUrl{?page}');
      when(() => client.get(Uri.parse(urlTemplate.expand({})), headers: {}))
          .thenAnswer((_) async => Response(firstUrlResponseBody, 200));
      when(() => client
              .get(Uri.parse(urlTemplate.expand({'page': 2})), headers: {}))
          .thenAnswer((_) async => Response(secondUrlResponseBody, 200));
      when(() => client
              .get(Uri.parse(urlTemplate.expand({'page': 3})), headers: {}))
          .thenAnswer((_) async => Response(thirdUrlResponseBody, 200));

      final result =
          await getPaginated(client, Uri.parse(urlTemplate.expand({})));
      expect(result.length, 3);
      expect(result[0]['name'], 'firstItem');
      expect(result[1]['name'], 'secondItem');
      expect(result[2]['name'], 'thirdItem');
    });

    test('throws api exception if at least one status codes was not 200',
        () async {
      final client = MockClient();
      final urlTemplate = UriTemplate('https://myUrl{?page}');
      when(() => client.get(Uri.parse(urlTemplate.expand({})), headers: {}))
          .thenAnswer((_) async => Response(firstUrlResponseBody, 200));
      when(() => client
              .get(Uri.parse(urlTemplate.expand({'page': 2})), headers: {}))
          .thenAnswer((_) async => Response(secondUrlResponseBody, 200));
      when(() => client
              .get(Uri.parse(urlTemplate.expand({'page': 3})), headers: {}))
          .thenAnswer((_) async => Response(thirdUrlResponseBody, 404));

      expect(getPaginated(client, Uri.parse(urlTemplate.expand({}))),
          throwsA(isA<RebrickableApiException>()));
    });
  });
}

class Dummy {
  final String name;
  Dummy(this.name);
}

const firstUrlResponseBody = '''{
  "count": 39932,
  "next": "https://myUrl?page=2",
  "previous": null,
  "results": [
    {"name": "firstItem"}
  ]
}''';

const secondUrlResponseBody = '''{
  "count": 39932,
  "next": "https://myUrl?page=3",
  "previous": "https://myUrl",
  "results": [
    {"name": "secondItem"}
  ]
}''';

const thirdUrlResponseBody = '''{
  "count": 39932,
  "next": null,
  "previous": "https://myUrl?page=2",
  "results": [
    {"name": "thirdItem"}
  ]
}''';
