part of 'register_cubit.dart';

@freezed
class RegisterState with _$RegisterState {
  const factory RegisterState({
    @Default(RegisterEvent.initial) RegisterEvent event,
    required UserAvatar userAvatar,
    required Username username,
    required EmailAddress email,
    required StrictPassword password,
    required Option<Either<AuthFailure, Unit>> failureOrSuccessOption,
  }) = _RegisterState;

  factory RegisterState.initial() => RegisterState(
        event: RegisterEvent.initial,
        userAvatar: UserAvatar(''),
        username: Username(''),
        email: EmailAddress(''),
        password: StrictPassword(''),
        failureOrSuccessOption: none(),
      );
}

@generate
enum RegisterEvent {
  initial,
  loading,
  error,
  success,
  avatarUpdated,
}
