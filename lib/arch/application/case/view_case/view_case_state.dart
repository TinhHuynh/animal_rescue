part of 'view_case_cubit.dart';

@freezed
class ViewCaseState with _$ViewCaseState {
  const factory ViewCaseState.initial() = _Initial;

  const factory ViewCaseState.loading() = _Loading;

  const factory ViewCaseState.caseLoaded(Case caze, bool isCreatedByUser) = _CaseLoaded;

  const factory ViewCaseState.loadCaseFailed(CaseFailure failure) =
      _LoadCaseFailure;

  const factory ViewCaseState.resolveCaseSuccessful() = _ResolveCaseSuccessful;

  const factory ViewCaseState.resolveCaseFailed(CaseFailure failure) =
      _ResolveCaseFailed;

  const factory ViewCaseState.deleteCaseSuccessful() = _DeleteCaseSuccessful;

  const factory ViewCaseState.deleteCaseFailed(CaseFailure failure) =
      _DeleteCaseFailed;
}

@generate
enum ViewCaseEvent {
  initial,
  loading,
  caseLoaded,
  loadCaseFailed,
  resolveCaseSuccessful,
  resolveCaseFailed,
  deleteCaseSuccessful,
  deleteCaseFailed
}
