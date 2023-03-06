part of 'home_cubit.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState(
      {required HomeEvent event,
      required Option<Either<LocationFailure, Location>> failureOrLocation,
      required Option<Either<AuthFailure, Unit>> logoutOption}) = _HomeState;

  factory HomeState.initial() =>
      HomeState(event: HomeEvent.initial, failureOrLocation: none(), logoutOption: none());
}

@generate
enum HomeEvent {
  initial,
  loading,
  locationError,
  locationUpdated,
  loggingOut,
  loggedOut,
  logOutFailed
}
