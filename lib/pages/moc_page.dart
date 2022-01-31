import 'package:brick_app/application/cubit/moc_page_cubit.dart';
import 'package:brick_app/injection.dart';
import 'package:brick_app/model/moc.dart';
import 'package:brick_app/model/set_or_moc.dart';
import 'package:brick_app/pages/pdf_page.dart';
import 'package:brick_app/widgets/brick_app_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MocPage extends StatelessWidget {
  final SetOrMoc brickSet;

  const MocPage(this.brickSet, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<MocPageCubit>(param1: brickSet.setNum)..getMocs(),
      child: BlocBuilder<MocPageCubit, MocPageState>(
        builder: (context, state) {
          switch (state.runtimeType) {
            case MocPageLoaded:
              return _successState(context, state as MocPageLoaded);
            case MocPageError:
              return _errorState(context, state as MocPageError);
            case MocPageLoading:
            default:
              return _loadingState(context, state);
          }
        },
      ),
    );
  }

  Scaffold _successState(BuildContext context, MocPageLoaded state) {
    final mocWithInstructions =
        state.mocs.where((moc) => moc.hasInstruction).toList(growable: false);
    return Scaffold(
      key: const Key('success'),
      appBar: BrickAppBar(Text('Mocs for ${brickSet.setNum}')),
      body: mocWithInstructions.isNotEmpty
          ? ListView.builder(
              itemBuilder: (context, index) =>
                  _buildListTile(context, mocWithInstructions[index]),
              itemCount: mocWithInstructions.length,
            )
          : const Center(child: Text('No mocs with instructions found')),
    );
  }

  Scaffold _loadingState(BuildContext context, MocPageState state) => Scaffold(
        key: const Key('loading'),
        appBar: BrickAppBar(const Text('Loading...')),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );

  Scaffold _errorState(BuildContext context, MocPageError state) => Scaffold(
        key: const Key('error'),
        appBar: BrickAppBar(const Text('Error')),
        body: Center(
          child: Text('An error occured: ${state.failure}'),
        ),
      );

  _buildListTile(BuildContext context, Moc moc) {
    return ListTile(
      onTap: moc.hasInstruction
          ? () async => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PdfPage(
                    setNum: brickSet.setNum,
                    mocNum: moc.setNum,
                  ),
                ),
              )
          : null,
      tileColor: moc.hasInstruction ? Colors.white : Colors.grey,
      title: SizedBox(
        height: 200,
        width: 200,
        child: CachedNetworkImage(
          imageUrl: moc.imgUrl,
          fit: BoxFit.scaleDown,
        ),
      ),
      subtitle: Text(moc.name),
    );
  }
}
