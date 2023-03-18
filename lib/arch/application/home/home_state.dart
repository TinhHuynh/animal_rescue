part of 'home_cubit.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState.initial() = _Initial;
  const factory HomeState.loading() = _Loading;
  const factory HomeState.locationUpdated(Location location) = _LocationUpdated;
  const factory HomeState.locationError(LocationFailure failure) = _LocationError;
  const factory HomeState.loggedOut() = _LoggedOut;
  const factory HomeState.logoutFailed(AuthFailure failure) = _LogoutFailed;
}