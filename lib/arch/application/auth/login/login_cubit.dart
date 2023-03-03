import 'package:animal_rescue/extensions/any_x.dart';
import 'package:dartz/dartz.dart';
import 'package:enum_annotation/enum_annotation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/auth/failures/auth_failure.dart';
import '../../../domain/auth/repositories/auth_repository.dart';
import '../../../domain/auth/value_objects/value_object.dart';

part 'login_cubit.freezed.dart';
part 'login_cubit.g.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this.authRepository) : super(LoginState.initial());
  final AuthRepository authRepository;

  updateEmail(String email) {
    emit(state.copyWith(email: EmailAddress(email)));
  }

  updatePassword(String password) {
    emit(state.copyWith(password: Password(password)));
  }

  Future<void> login() async {
    if (state.email.isValid() && state.password.isValid()) {
      emit(state.copyWith(event: Event.submitting));
      final result = await authRepository.loginWithEmailAndPassword(
          state.email, state.password);
      emit(result.fold((l) => state.copyError(l),
          (r) => state.copyWith(event: Event.success)));
    } else {
      emit(state
          .copyError((const AuthFailure.invalidEmailAndPasswordCombination())));
    }
  }
}
