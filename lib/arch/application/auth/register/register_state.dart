part of 'register_cubit.dart';

@freezed
class RegisterState with _$RegisterState {
  const factory RegisterState.initial() = _Initial;
  const factory RegisterState.submitting() = _Submitting;
  const factory RegisterState.success() = _Success;
  const factory RegisterState.error(AuthFailure failure) = _Error;
}
