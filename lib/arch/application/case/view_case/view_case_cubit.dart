import 'package:enum_annotation/enum_annotation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/auth/repositories/auth_repository.dart';
import '../../../domain/case/entities/case.dart';
import '../../../domain/case/failures/failure.dart';
import '../../../domain/case/repositories/case_repository.dart';
import '../../../domain/core/value_objects.dart';

part 'view_case_cubit.freezed.dart';

part 'view_case_cubit.g.dart';

part 'view_case_state.dart';

class ViewCaseCubit extends Cubit<ViewCaseState> {
  final CaseRepository _caseRepository;
  final AuthRepository _authRepository;

  ViewCaseCubit(this._caseRepository, this._authRepository)
      : super(const ViewCaseState.initial());

  fetchCase(UniqueId caseId) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      emit(const ViewCaseState.loading());
      final result = await _caseRepository.getCase(caseId);
      emit(result.fold(
          (l) => ViewCaseState.loadCaseFailed(l), (r) => _caseLoadedData(r)));
    });
  }

  ViewCaseState _caseLoadedData(Case caze) {
    final createdByUser =
        _authRepository.getUserId()! == caze.userId.getOrCrash();
    return ViewCaseState.caseLoaded(caze, createdByUser);
  }

  resolveCase(Case caze) {
    emit(const ViewCaseState.loading());
    _caseRepository.resolveCase(caze).then((value) => emit(value.fold(
        (l) => ViewCaseState.resolveCaseFailed(l),
        (r) => const ViewCaseState.resolveCaseSuccessful())));
  }

  deleteCase(Case caze) {
    emit(const ViewCaseState.loading());
    _caseRepository.deleteCase(caze).then((value) => emit(value.fold(
            (l) => ViewCaseState.deleteCaseFailed(l),
            (r) => const ViewCaseState.deleteCaseSuccessful())));
  }
}
