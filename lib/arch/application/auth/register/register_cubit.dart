import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/auth/failures/auth_failure.dart';
import '../../../domain/auth/repositories/auth_repository.dart';
import '../../../domain/auth/value_objects/value_object.dart';

part 'register_cubit.freezed.dart';

part 'register_state.dart';
@injectable
class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepository _authRepository;

  RegisterCubit(this._authRepository) : super(const RegisterState.initial());

  register(UserAvatar? userAvatar, Username username, EmailAddress email,
      StrictPassword password) async {
    if (!_checkValid(username, email, password)) {
      return;
    }
    emit(const RegisterState.submitting());
    final result = await _authRepository.registerWithEmailAndPassword(
        userAvatar, username, email, password);
    emit(result.fold(
        (l) => RegisterState.error(l), (r) => const RegisterState.success()));
  }

  bool _checkValid(
      Username username, EmailAddress email, StrictPassword password) {
    if (!username.isValid()) {
      emit(const RegisterState.error(AuthFailure.invalidUsername()));
      return false;
    }
    if (!email.isValid()) {
      emit(const RegisterState.error(AuthFailure.invalidEmail()));
      return false;
    }
    if (!password.isValid()) {
      emit(const RegisterState.error(AuthFailure.invalidPassword()));
      return false;
    }
    return true;
  }
}
