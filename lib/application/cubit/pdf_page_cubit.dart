import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:brick_app/core/failure.dart';
import 'package:brick_app/infrastructure/moc/moc_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

part 'pdf_page_state.dart';

class PdfPageCubit extends Cubit<PdfPageState> {
  final MocRepository _mocRepository;
  final String setNum;
  final String mocNum;

  PdfPageCubit(this._mocRepository,
      {required this.setNum, required this.mocNum})
      : super(PdfPageLoading()) {
    _downloadPdf();
  }

  _downloadPdf() async {
    final result = await _mocRepository.getBuildInstruction(
        setNum: setNum, mocNum: mocNum);
    result.fold((failure) {
      log('Error downloading file.');
      emit(PdfPageError(failure));
    }, (pdfFile) async {
      final pdfDocument = await PdfDocument.openFile(pdfFile.path);
      emit(PdfPageLoaded(pdfDocument));
    });
  }
}
