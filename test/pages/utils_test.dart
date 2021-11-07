import 'package:brick_app/pages/utils.dart';
import 'package:brick_app/widgets/create_delete_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  const String title = 'title';
  const String label = 'label';
  const Key inputFieldKey = Key('inputFieldKey');
  const String okButtonText = 'okButtonText';

  Future<String> onOkButtonPress(input) async => Future.value('');

  void showDialogWithDefaults(BuildContext context,
          {AsyncValueSetter<String>? providedCallback}) =>
      showInputDialog(context,
          title: title,
          label: label,
          inputFieldKey: inputFieldKey,
          onOkButtonPress: providedCallback ?? onOkButtonPress,
          okButtonText: okButtonText);

  Future<BuildContext> _createAndPumpApp(WidgetTester tester) async {
    late BuildContext buildContext;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            buildContext = context;
            return const Placeholder();
          },
        ),
      ),
    );
    return buildContext;
  }

  group('showInputDialog', () {
    testWidgets('renders dialog', (tester) async {
      BuildContext context = await _createAndPumpApp(tester);
      showDialogWithDefaults(context);

      await tester.pump();

      expect(find.byType(CreateDeleteDialog), findsOneWidget);
    });

    testWidgets('shows title', (tester) async {
      BuildContext context = await _createAndPumpApp(tester);
      showDialogWithDefaults(context);

      await tester.pump();

      expect(find.text(title), findsOneWidget);
    });

    group('text form field', () {
      testWidgets('shows form field', (tester) async {
        BuildContext context = await _createAndPumpApp(tester);
        showDialogWithDefaults(context);

        await tester.pump();

        final Finder textFormFieldFinder = find.byType(TextFormField);
        expect(textFormFieldFinder, findsOneWidget);

        expect(
            find.descendant(
                of: textFormFieldFinder, matching: find.text(label)),
            findsOneWidget);
      });
    });

    group('ok button', () {
      testWidgets('shows ok button text', (tester) async {
        BuildContext context = await _createAndPumpApp(tester);
        showDialogWithDefaults(context);

        await tester.pump();

        final Finder okButtonFinder = find.byType(ElevatedButton);
        expect(okButtonFinder, findsNWidgets(2));

        expect(
            find.descendant(
                of: okButtonFinder, matching: find.text(okButtonText)),
            findsOneWidget);
      });

      testWidgets('does not call onOkButtonPress if input is empty',
          (tester) async {
        bool called = false;
        BuildContext context = await _createAndPumpApp(tester);
        showDialogWithDefaults(context,
            providedCallback: (_) async => called = true);

        await tester.pump();

        await tester.tap(find.descendant(
            of: find.byType(ElevatedButton),
            matching: find.text(okButtonText)));

        expect(called, false);
      });

      testWidgets('does call onOkButtonPress if input is not empty',
          (tester) async {
        bool called = false;
        BuildContext context = await _createAndPumpApp(tester);
        showDialogWithDefaults(context,
            providedCallback: (_) async => called = true);

        await tester.pump();

        await tester.enterText(find.byKey(inputFieldKey), 'text');

        await tester.pump();

        await tester.tap(find.descendant(
            of: find.byType(ElevatedButton),
            matching: find.text(okButtonText)));

        expect(called, true);
      });
    });
  });
}
