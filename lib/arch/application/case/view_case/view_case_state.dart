part of 'view_case_cubit.dart';

@freezed
class ViewCaseState with _$ViewCaseState {
  const factory ViewCaseState({
    required ViewCaseEvent event,
    required bool isCreatedByUser,
    required Option<Either<CaseFailure, Case>> loadCaseOption,
    required Option<Either<CaseFailure, Unit>> resolveCaseOption,
    required Option<Either<CaseFailure, Unit>> deleteCaseOption,
  }) = _ViewCaseState;

  factory ViewCaseState.initial() => ViewCaseState(
        event: ViewCaseEvent.initial,
        isCreatedByUser: false,
        loadCaseOption: none(),
        resolveCaseOption: none(),
        deleteCaseOption: none(),
      );

  const ViewCaseState._();
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
