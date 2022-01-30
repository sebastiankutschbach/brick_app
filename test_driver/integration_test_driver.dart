import 'package:brick_app/injection.dart';
import 'package:integration_test/integration_test_driver.dart'
    as integration_test_driver;

Future<void> main() {
  // The Gherkin report data send back to this runner by the app after
  // the tests have run will be saved to this directory
  integration_test_driver.testOutputsDirectory =
      'build/integration_test/gherkin/reports';

  getIt.allowReassignment = true;

  return integration_test_driver.integrationDriver(
    timeout: const Duration(minutes: 90),
  );
}
