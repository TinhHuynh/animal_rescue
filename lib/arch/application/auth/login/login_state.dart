part of 'login_cubit.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState({
    @Default(Event.none) Event event,
    required EmailAddress email,
    required Password password,
    required Option<Either<AuthFailure, Unit>> loginOption,
  }) = _LoginState;

  factory LoginState.initial() => LoginState(
        email: EmailAddress(''),
        password: Password(''),
        loginOption: none(),
      );

  const LoginState._();

  copyError(AuthFailure failure) => copyWith(event: Event.error, loginOption: some(left(failure)));

  bool get canRebuild =>
      event.isOneOf([Event.success, Event.submitting, Event.error]);
}

@generate
enum Event {
  none,
  submitting,
  error,
  success;
}
