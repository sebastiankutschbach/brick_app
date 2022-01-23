import 'package:brick_app/application/cubit/login_page_cubit.dart';
import 'package:brick_app/infrastructure/service/preferences_service.dart';
import 'package:brick_app/infrastructure/service/rebrickable_service.dart';
import 'package:brick_app/model/moc.dart';
import 'package:brick_app/model/rebrickable_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';

class MockPreferencesService extends Mock implements PreferencesService {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockRebrickableModel extends Mock implements RebrickableModel {}

class MockRebrickableService extends Mock implements RebrickableService {}

class MockMoc extends Mock implements Moc {}

class MockClient extends Mock implements Client {}

class MockLoginPageCubit extends MockCubit<LoginPageState>
    implements LoginPageCubit {}
