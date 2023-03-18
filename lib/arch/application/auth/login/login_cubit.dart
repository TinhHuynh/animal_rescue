import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/auth/failures/auth_failure.dart';
import '../../../domain/auth/repositories/auth_repository.dart';
import '../../../domain/auth/value_objects/value_object.dart';

part 'login_cubit.freezed.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this.authRepository) : super(const LoginState.initial());
  final AuthRepository authRepository;

  Future<void> login(EmailAddress email, Password password) async {
    if (email.isValid() && password.isValid()) {
      emit(const LoginState.submitting());
      final result =
          await authRepository.loginWithEmailAndPassword(email, password);
      emit(result.fold(
          (l) => LoginState.error(l), (r) => const LoginState.success()));
    } else {
      emit(const LoginState.error(
          AuthFailure.invalidEmailAndPasswordCombination()));
    }
  }
}
