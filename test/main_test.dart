import 'package:brick_app/main.dart';
import 'package:brick_app/pages/login_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'mocks.dart';

main() {
  group('login', () {
    testWidgets('login page is shown when user token is not yet persisted',
        (tester) async {
      final preferencesService = PreferencesServiceMock();
      when(preferencesService.userToken).thenReturn('');
      await tester.pumpWidget(MyApp(
        preferencesService: preferencesService,
        rebrickableModel: RebrickableModelMock(),
      ));

      expect(find.byType(LoginPage), findsOneWidget);
    });

    testWidgets(
        'login page does redirect directly when user token is persisted',
        (tester) async {
      final preferencesService = PreferencesServiceMock();
      final rebrickableModel = RebrickableModelMock();
      when(preferencesService.apiKey).thenReturn('apiKey');
      when(preferencesService.userToken).thenReturn('myUserToken');
      when(rebrickableModel.loginWithToken('myUserToken', 'apiKey'))
          .thenAnswer((_) async => 'myUserToken');
      await tester.pumpWidget(MyApp(
          preferencesService: preferencesService,
          rebrickableModel: rebrickableModel));

      await tester.pump(const Duration(milliseconds: 300));

      verify(rebrickableModel.loginWithToken('myUserToken', 'apiKey'))
          .called(1);
    });
  });
}
