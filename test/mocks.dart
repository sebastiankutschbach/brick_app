import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:brick_app/application/cubit/pdf_page_cubit.dart';
import 'package:brick_app/infrastructure/moc/moc_repository.dart';
import 'package:brick_app/model/moc.dart';
import 'package:brick_app/model/rebrickable_model.dart';
import 'package:brick_app/service/preferences_service.dart';
import 'package:brick_app/service/rebrickable_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

class MockPreferencesService extends Mock implements PreferencesService {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockRebrickableModel extends Mock implements RebrickableModel {}

class MockRebrickableService extends Mock implements RebrickableService {}

class MockMoc extends Mock implements Moc {}

class MockClient extends Mock implements Client {}

class MockMocRepository extends Mock implements MocRepository {}

class MockFile extends Mock implements File {}

class MockPdfPageCubit extends MockCubit<PdfPageState> implements PdfPageCubit {
}

class MockPdfDocument extends Mock implements PdfDocument {}
