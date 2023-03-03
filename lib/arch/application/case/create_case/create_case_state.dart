part of 'create_case_cubit.dart';

@freezed
class CreateCaseState with _$CreateCaseState {
  const factory CreateCaseState(
          {required CreateCaseEvent event,
          required Location location,
          required CaseTitle title,
          required CaseDescription description,
          required CaseAddress address,
          required List3<CaseLocalPhoto> photos,
          required Option<Either<CaseFailure, Unit>> inputOption,
          required Option<Either<CaseFailure, UniqueId>> submitOption}) =
      _CreateCubitState;

  factory CreateCaseState.initial() => CreateCaseState(
      title: CaseTitle(''),
      description: CaseDescription(''),
      address: CaseAddress(''),
      photos: List3<CaseLocalPhoto>(const []),
      event: CreateCaseEvent.initial,
      inputOption: none(),
      submitOption: none(),
      location: Location.double(latitude: 0.0, longitude: 0.0));

  const CreateCaseState._();

  CreateCaseState onError(CaseFailure failure) {
    return copyWith(
        event: CreateCaseEvent.inputFailed,
        inputOption: some(left(failure)));
  }
}

@generate
enum CreateCaseEvent {
  initial,
  inputting,
  inputFailed,
  addPhoto,
  removePhoto,
  submitting,
  submitSuccess,
  submitFailed
}
