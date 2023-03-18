part of 'create_case_cubit.dart';

@freezed
class CreateCaseState with _$CreateCaseState {
  factory CreateCaseState.initial() = _Initial;

  factory CreateCaseState.submitting() = _Submitting;

  factory CreateCaseState.submitSuccess(UniqueId id) = _SubmitSuccess;

  factory CreateCaseState.submitFailed(CaseFailure failure) = _SubmitFailed;
}
