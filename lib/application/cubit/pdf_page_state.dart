part of 'pdf_page_cubit.dart';

abstract class PdfPageState extends Equatable {
  const PdfPageState();

  @override
  List<Object> get props => [];
}

class PdfPageLoading extends PdfPageState {}

class PdfPageError extends PdfPageState {
  final Failure failure;

  const PdfPageError(this.failure);

  @override
  List<Object> get props => [failure];
}

class PdfPageLoaded extends PdfPageState {
  final PdfDocument pdfDocument;

  const PdfPageLoaded(this.pdfDocument);

  @override
  List<Object> get props => [pdfDocument];
}
