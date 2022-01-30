// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'application/cubit/pdf_page_cubit.dart' as _i4;
import 'infrastructure/moc/moc_repository.dart'
    as _i3; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  gh.factory<_i3.MocRepositoryFacade>(() => _i3.MocRepository());
  gh.factoryParam<_i4.PdfPageCubit, String?, String?>((setNum, mocNum) =>
      _i4.PdfPageCubit(get<_i3.MocRepositoryFacade>(),
          setNum: setNum, mocNum: mocNum));
  return get;
}
