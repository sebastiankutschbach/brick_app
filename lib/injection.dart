import 'package:brick_app/injection.config.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:injectable/injectable.dart';

final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() {
  getIt.registerFactory<Client>(() => Client());
  $initGetIt(getIt);
}
