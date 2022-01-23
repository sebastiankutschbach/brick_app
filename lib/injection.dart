import 'package:brick_app/application/cubit/login_page_cubit.dart';
import 'package:brick_app/infrastructure/service/preferences_service.dart';
import 'package:brick_app/infrastructure/service/rebrickable_service.dart';
import 'package:brick_app/model/rebrickable_model.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  final preferencesService = PreferencesService();
  await preferencesService.initPreferences();
  final rebrickableService = RebrickableService();
  final rebrickableModel =
      RebrickableModel(rebrickableService: rebrickableService);

  getIt.registerSingleton<PreferencesService>(preferencesService);
  getIt.registerSingleton<RebrickableService>(rebrickableService);
  getIt.registerSingleton<RebrickableModel>(rebrickableModel);

  getIt.registerFactory<LoginPageCubit>(
      () => LoginPageCubit(preferencesService, rebrickableModel));
}
