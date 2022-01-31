import 'package:brick_app/application/cubit/pdf_page_cubit.dart';
import 'package:brick_app/injection.dart';
import 'package:brick_app/widgets/brick_app_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:url_launcher/url_launcher.dart';

class PdfPage extends StatelessWidget {
  final String setNum;
  final String mocNum;

  const PdfPage({required this.setNum, required this.mocNum, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) =>
            getIt<PdfPageCubit>(param1: setNum, param2: mocNum)..getPdf(),
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

  Scaffold _successState(BuildContext context, PdfPageLoaded state) => kIsWeb
      ? _successStateWeb(context, state)
      : _successStateApp(context, state);

  Scaffold _successStateApp(BuildContext context, PdfPageLoaded state) {
    final doc = state.pdfDocument.toNullable();
    PdfController controller = PdfController(document: Future.value(doc));
    return Scaffold(
      key: const Key('success'),
      appBar: BrickAppBar(Text(mocNum)),
      body: PdfView(controller: controller),
    );
  }

  Scaffold _successStateWeb(BuildContext context, PdfPageLoaded state) {
    final url = state.pdfDocumentUri.toNullable();
    launch(url.toString());
    return Scaffold(
      key: const Key('success'),
      appBar: BrickAppBar(Text(mocNum)),
      body: const Center(
        child: Text('PDF will be opened in another tab'),
      ),
    );
  }

  Scaffold _loadingState(BuildContext context, PdfPageState state) => Scaffold(
        key: const Key('loading'),
        appBar: BrickAppBar(Text(mocNum)),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );

  Scaffold _errorState(BuildContext context, PdfPageError state) => Scaffold(
        key: const Key('error'),
        appBar: BrickAppBar(Text(mocNum)),
        body: Center(
          child: Text('An error occured: ${state.failure}'),
        ),
      );
}
