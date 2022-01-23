part of 'login_page_cubit.dart';

@immutable
class LoginPageState extends Equatable {
  final Either<Failure, String> username;
  final Either<Failure, String> password;

  const LoginPageState(this.username, this.password);

  @override
  List<Object?> get props => [username, password];

  LoginPageState copyWith(
          {Either<Failure, String>? username,
          Either<Failure, String>? password}) =>
      LoginPageState(username ?? this.username, password ?? this.password);
}

class LoginPageInitial extends LoginPageState {
  LoginPageInitial() : super(right(""), right(""));
}

class LoginPageLoginSucceeded extends LoginPageState {
  const LoginPageLoginSucceeded(
      Either<Failure, String> username, Either<Failure, String> password)
      : super(username, password);
}

class LoginPageLoginFailed extends LoginPageState {
  final Failure failure;
  const LoginPageLoginFailed(this.failure, Either<Failure, String> username,
      Either<Failure, String> password)
      : super(username, password);

  @override
  List<Object?> get props => [failure, username, password];
}
