part of 'login_cubit.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState.initial() = _Initial;
  const factory LoginState.submitting() = _Submitting;
  const factory LoginState.error(AuthFailure failure) = _Error;
  const factory LoginState.success() = _Success;
}
