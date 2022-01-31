import 'package:bloc/bloc.dart';
import 'package:brick_app/core/failure.dart';
import 'package:brick_app/infrastructure/moc/moc_repository.dart';
import 'package:brick_app/model/moc.dart';
import 'package:brick_app/service/rebrickable_api_exception.dart';
import 'package:brick_app/service/rebrickable_service.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'moc_page_state.dart';

@Injectable()
class MocPageCubit extends Cubit<MocPageState> {
  final MocRepositoryFacade _mocRepository;
  final RebrickableService rebrickableService;
  final String? setNum;

  MocPageCubit(this._mocRepository, this.rebrickableService,
      {@factoryParam this.setNum})
      : super(MocPageLoading());

  void getMocs() async {
    emit(MocPageLoading());

    try {
      final mocs = await rebrickableService.getMocsFromSet(setNum: setNum!);

      final existingMocNums =
          await _mocRepository.areBuildInstructionsAvailable(
        setNum: setNum!,
        mocNums: List<String>.from(
          mocs.map((moc) => moc.setNum),
        ),
      );
      for (final moc in mocs) {
        moc.hasInstruction = existingMocNums.contains(moc.setNum);
      }
      emit(MocPageLoaded(mocs));
    } on RebrickableApiException catch (e) {
      emit(MocPageError(Failure(e.message.toString())));
    }
  }
}
