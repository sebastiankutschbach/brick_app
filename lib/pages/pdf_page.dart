import 'package:brick_app/application/cubit/pdf_page_cubit.dart';
import 'package:brick_app/infrastructure/moc/moc_repository.dart';
import 'package:brick_app/widgets/brick_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

class PdfPage extends StatelessWidget {
  final String setNum;
  final String mocNum;

  const PdfPage({required this.setNum, required this.mocNum, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) =>
            PdfPageCubit(MocRepository(), setNum: setNum, mocNum: mocNum),
        child: BlocBuilder<PdfPageCubit, PdfPageState>(
          builder: (context, state) {
            switch (state.runtimeType) {
              case PdfPageLoaded:
                return _successState(context, state as PdfPageLoaded);
              case PdfPageError:
                return _errorState(context, state as PdfPageError);
              case PdfPageLoading:
              default:
                return _loadingState(context, state);
            }
          },
        ),
      );

  Scaffold _successState(BuildContext context, PdfPageLoaded state) {
    PdfController controller =
        PdfController(document: Future.value(state.pdfDocument));
    return Scaffold(
      appBar: BrickAppBar(Text(mocNum)),
      body: PdfView(controller: controller),
    );
  }

  Scaffold _loadingState(BuildContext context, PdfPageState state) => Scaffold(
        appBar: BrickAppBar(Text(mocNum)),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );

  Scaffold _errorState(BuildContext context, PdfPageError state) => Scaffold(
        appBar: BrickAppBar(Text(mocNum)),
        body: Center(
          child: Text('An error occured: ${state.failure}'),
        ),
      );
}
