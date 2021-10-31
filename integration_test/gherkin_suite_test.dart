// The application under test.

// ignore_for_file: avoid_print

import 'package:brick_app/main.dart' as app;
import 'package:flutter_gherkin/flutter_gherkin.dart'; // notice new import name
import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin/gherkin.dart';

import 'gherkin/steps/given/fresh_app.dart';
import 'gherkin/steps/then/expect_widget_visible.dart';
import 'gherkin/steps/when/login.dart';
import 'gherkin/steps/when/logout.dart';

part 'gherkin_suite_test.g.dart';

@GherkinTestSuite()
void main() {
  executeTestSuite(
    FlutterTestConfiguration.DEFAULT([])
      ..stepDefinitions = [
        freshApp(),
        login(),
        logout(),
        expectWidgetVisible(),
        TextExistsStep()
      ]
      ..reporters = [
        StdoutReporter(MessageLevel.error)
          ..setWriteLineFn(print)
          ..setWriteFn(print),
        ProgressReporter()
          ..setWriteLineFn(print)
          ..setWriteFn(print),
        TestRunSummaryReporter()
          ..setWriteLineFn(print)
          ..setWriteFn(print),
        JsonReporter(
          writeReport: (_, __) => Future<void>.value(),
        ),
      ],
    (World world) =>
        Future.delayed(const Duration(seconds: 0), () => app.main()),
  );
}
