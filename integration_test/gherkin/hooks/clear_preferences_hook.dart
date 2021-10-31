import 'package:gherkin/gherkin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClearPreferencesHook extends Hook {
  @override
  int get priority => 1;

  @override
  Future<void> onAfterScenario(
    TestConfiguration config,
    String scenario,
    Iterable<Tag> tags,
  ) async {
    print("running hook after scenario '$scenario'");
    await (await SharedPreferences.getInstance()).clear();
  }
}
