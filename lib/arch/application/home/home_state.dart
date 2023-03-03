part of 'home_cubit.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState(
      {required HomeEvent event,
      required Option<Either<LocationFailure, Location>>
          failureOrLocation}) = _HomeState;

  factory HomeState.initial() => HomeState(
      event: HomeEvent.initial,
      failureOrLocation: none());
}

@generate
enum HomeEvent {
  initial,
  loading,
  locationError,
  locationUpdated
}
