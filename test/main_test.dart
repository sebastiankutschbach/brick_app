import 'package:brick_app/main.dart';
import 'package:brick_app/pages/login_page.dart';
import 'package:brick_app/service/preferences_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class PreferencesServiceMock extends Mock implements PreferencesService {}

main() {
  group('login', () {
    testWidgets('login page is shown when user token is not yet persisted',
        (tester) async {
      final preferencesService = PreferencesServiceMock();
      when(preferencesService.userToken).thenReturn(null);
      await tester.pumpWidget(MyApp(preferencesService: preferencesService));

      expect(find.byType(LoginPage), findsOneWidget);
    });

    testWidgets('login page is NOT shown when user token is persisted',
        (tester) async {
      final preferencesService = PreferencesServiceMock();
      when(preferencesService.userToken).thenReturn('myUserToken');
      await tester.pumpWidget(MyApp(preferencesService: preferencesService));

      expect(find.byType(LoginPage), findsNothing);
    });
  });
}
