part of 'moc_page_cubit.dart';

abstract class MocPageState extends Equatable {
  const MocPageState();

  @override
  List<Object> get props => [];
}

class MocPageLoading extends MocPageState {}

class MocPageError extends MocPageState {
  final Failure failure;

  const MocPageError(this.failure);

  @override
  List<Object> get props => [failure];
}

class MocPageLoaded extends MocPageState {
  final List<Moc> mocs;

  const MocPageLoaded(this.mocs);

  @override
  List<Object> get props => [mocs];
}
