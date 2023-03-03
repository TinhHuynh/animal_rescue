import 'package:dartz/dartz.dart';
import 'package:enum_annotation/enum_annotation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/auth/failures/auth_failure.dart';
import '../../../domain/auth/repositories/auth_repository.dart';
import '../../../domain/auth/value_objects/value_object.dart';

part 'register_cubit.freezed.dart';

part 'register_cubit.g.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepository _authRepository;

  RegisterCubit(this._authRepository) : super(RegisterState.initial());

  updateAvatar(String path) {
    emit(state.copyWith(
        event: RegisterEvent.avatarUpdated, userAvatar: UserAvatar(path)));
  }

  updateUsername(String username) {
    emit(state.copyWith(username: Username(username)));
  }

  updateEmail(String email) {
    emit(state.copyWith(email: EmailAddress(email)));
  }

  updatePassword(String password) {
    emit(state.copyWith(password: StrictPassword(password)));
  }

  register() async {
    if (!_checkValid()) {
      return;
    }
    emit(state.copyWith(event: RegisterEvent.loading));
    final result = await _authRepository.registerWithEmailAndPassword(
        state.userAvatar, state.username, state.email, state.password);
    emit(result.fold(
        (l) => state.copyWith(
            event: RegisterEvent.error, failureOrSuccessOption: some(left(l))),
        (r) => state.copyWith(
            event: RegisterEvent.success,
            failureOrSuccessOption: some(right(unit)))));
  }

  bool _checkValid() {
    if (!state.username.isValid()) {
      emit(state.copyWith(
          event: RegisterEvent.error,
          failureOrSuccessOption:
              some(left(const AuthFailure.invalidUsername()))));
      return false;
    }
    if (!state.email.isValid()) {
      emit(state.copyWith(
          event: RegisterEvent.error,
          failureOrSuccessOption:
              some(left(const AuthFailure.invalidEmail()))));
      return false;
    }
    if (!state.password.isValid()) {
      emit(state.copyWith(
          event: RegisterEvent.error,
          failureOrSuccessOption:
              some(left(const AuthFailure.invalidPassword()))));
      return false;
    }
    return true;
  }
}
