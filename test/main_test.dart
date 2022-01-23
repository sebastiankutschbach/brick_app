import 'package:brick_app/main.dart';
import 'package:brick_app/presentation/pages/login_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'mocks.dart';

main() {
  group('login', () {
    testWidgets('login page is shown when user token is not yet persisted',
        (tester) async {
      final preferencesService = MockPreferencesService();
      when(() => preferencesService.userToken).thenReturn('');
      when(() => preferencesService.apiKey).thenReturn('');
      await tester.pumpWidget(MyApp(
        preferencesService: preferencesService,
        rebrickableModel: MockRebrickableModel(),
      ));

      expect(find.byType(LoginPage), findsOneWidget);
    });

    testWidgets(
        'login page does redirect directly when user token is persisted',
        (tester) async {
      final preferencesService = MockPreferencesService();
      final rebrickableModel = MockRebrickableModel();
      when(() => preferencesService.apiKey).thenReturn('apiKey');
      when(() => preferencesService.userToken).thenReturn('myUserToken');
      when(() => rebrickableModel.loginWithToken('myUserToken', 'apiKey'))
          .thenAnswer((_) async => 'myUserToken');
      when(() => rebrickableModel.getUsersSetLists())
          .thenAnswer((_) async => Future.value([]));
      await tester.pumpWidget(MyApp(
          preferencesService: preferencesService,
          rebrickableModel: rebrickableModel));

      await tester.pump(const Duration(milliseconds: 300));

      verify(() => rebrickableModel.loginWithToken('myUserToken', 'apiKey'))
          .called(1);
    });
  });
}
