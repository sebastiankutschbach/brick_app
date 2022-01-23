import 'package:bloc/bloc.dart';
import 'package:brick_app/domain/failure.dart';
import 'package:brick_app/infrastructure/service/preferences_service.dart';
import 'package:brick_app/infrastructure/service/rebrickable_api_exception.dart';
import 'package:brick_app/model/rebrickable_model.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'login_page_state.dart';

class LoginPageCubit extends Cubit<LoginPageState> {
  final RebrickableModel rebrickableModel;
  final PreferencesService preferencesService;

  LoginPageCubit(this.preferencesService, this.rebrickableModel)
      : super(LoginPageInitial());

  void usernameChanged(String username) {
    _validateUsername(username);
    final validationResult = _validatePassword(username);
    validationResult.fold(
      () => emit(
        state.copyWith(
          username: right(username),
        ),
      ),
      (failure) => emit(
        state.copyWith(
          username: left(failure),
        ),
      ),
    );
  }

  void passwordChanged(String password) {
    final validationResult = _validatePassword(password);
    validationResult.fold(
      () => emit(
        state.copyWith(
          password: right(password),
        ),
      ),
      (failure) => emit(
        state.copyWith(
          password: left(failure),
        ),
      ),
    );
  }

  login() async {
    if (preferencesService.apiKey.isEmpty) {
      emit(
        LoginPageLoginFailed(
            const Failure('Please set your api key under settings'),
            state.username,
            state.password),
      );
      return;
    }
    if (_validateUsername(state.username.getOrElse(() => "")).isSome()) {
      emit(
        LoginPageLoginFailed(const Failure('Username cannot be empty'),
            state.username, state.password),
      );
      return;
    }
    if (_validateUsername(state.password.getOrElse(() => "")).isSome()) {
      emit(
        LoginPageLoginFailed(const Failure('Password cannot be empty'),
            state.username, state.password),
      );
      return;
    }
    try {
      final userToken = await rebrickableModel.login(
          state.username.getOrElse(() => throw ('Username empty')),
          state.password.getOrElse(() => throw ('Password empty')),
          preferencesService.apiKey);
      if (userToken.isNotEmpty) {
        preferencesService.userToken = userToken;
        emit(LoginPageLoginSucceeded(state.username, state.password));
      } else {
        emit(
          LoginPageLoginFailed(const Failure('Could not retrieve user token'),
              state.username, state.password),
        );
      }
    } on RebrickableApiException catch (e) {
      emit(
        LoginPageLoginFailed(
            Failure(e.message), state.username, state.password),
      );
    }
  }

  Option<Failure> _validateUsername(String username) {
    if (username.isEmpty) {
      return some(const Failure('Username can not be empty'));
    }
    return none();
  }

  Option<Failure> _validatePassword(String password) {
    if (password.isEmpty) {
      return some(const Failure('Password can not be empty'));
    }
    return none();
  }
}
