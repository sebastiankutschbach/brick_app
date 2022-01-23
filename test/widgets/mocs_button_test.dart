import 'package:brick_app/presentation/widgets/mocs_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks.dart';
import '../model/brick_set_test.dart';

main() {
  Widget _createApp({NavigatorObserver? navigatorObserver}) => MaterialApp(
        home: Scaffold(
          body: MocsButton(testBrickSet),
        ),
        navigatorObservers: [navigatorObserver ?? MockNavigatorObserver()],
      );

  setUpAll(() {
    registerFallbackValue(MaterialPageRoute(builder: (_) => const Text('')));
  });

  testWidgets('renders correctly', (tester) async {
    await tester.pumpWidget(_createApp());

    expect(find.byType(Icon), findsOneWidget);
    expect(find.text('MOCs'), findsOneWidget);
  });

  testWidgets('navigates to moc url', (tester) async {
    final navigatorObserver = MockNavigatorObserver();
    await tester.pumpWidget(_createApp(navigatorObserver: navigatorObserver));

    await tester.tap(find.byType(MocsButton));

    List<MaterialPageRoute> captured =
        verify(() => navigatorObserver.didPush(captureAny(), any()))
            .captured
            .cast<MaterialPageRoute>();
    expect(captured.last.settings.name, 'mocsRoute');
  });
}
