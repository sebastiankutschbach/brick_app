import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:brick_app/core/failure.dart';
import 'package:brick_app/infrastructure/moc/moc_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

part 'pdf_page_state.dart';

@Injectable()
class PdfPageCubit extends Cubit<PdfPageState> {
  final MocRepositoryFacade _mocRepository;
  final String? setNum;
  final String? mocNum;

  PdfPageCubit(this._mocRepository,
      {@factoryParam this.setNum, @factoryParam this.mocNum})
      : super(PdfPageLoading()) {
    _getPdf();
  }

  _getPdf() async {
    kIsWeb ? _getPdfUrl() : _downloadPdfFile();
  }

  _downloadPdfFile() async {
    final result = await _mocRepository.getBuildInstruction(
        setNum: setNum!, mocNum: mocNum!);
    result.fold((failure) {
      log('Error downloading file.');
      emit(PdfPageError(failure));
    }, (pdfFile) async {
      final pdfDocument = await PdfDocument.openFile(pdfFile.path);
      emit(PdfPageLoaded(some(pdfDocument), none()));
    });
  }

  _getPdfUrl() async {
    final result = await _mocRepository.getBuildInstructionUrl(
        setNum: setNum!, mocNum: mocNum!);
    result.fold((failure) {
      log('Error getting presigned url.');
      emit(PdfPageError(failure));
    }, (pdfUrl) async {
      emit(PdfPageLoaded(none(), some(pdfUrl)));
    });
  }
}
