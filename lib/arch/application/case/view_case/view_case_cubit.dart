import 'package:dartz/dartz.dart';
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
      : super(ViewCaseState.initial());

  fetchCase(UniqueId caseId, Case? caze) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      emit(state.copyWith(event: ViewCaseEvent.loading));
      if (caze != null) {
        emit(_caseLoadedData(caze));
        return;
      }
      final result = await _caseRepository.getCase(caseId);
      emit(result.fold(
          (l) => state.copyWith(
              event: ViewCaseEvent.loadCaseFailed,
              loadCaseOption: some(left(l))),
          (r) => _caseLoadedData(r)));
    });
  }

  ViewCaseState _caseLoadedData(Case caze) {
    final createdByUser =
        _authRepository.getUserId()! == caze.userId.getOrCrash();
    return state.copyWith(
        event: ViewCaseEvent.caseLoaded,
        isCreatedByUser: createdByUser,
        loadCaseOption: some(right(caze)));
  }

  resolveCase(Case caze) {
    emit(state.copyWith(event: ViewCaseEvent.loading));
    _caseRepository.resolveCase(caze).then((value) => emit(state.copyWith(
        event: value.fold((l) => ViewCaseEvent.resolveCaseFailed,
            (r) => ViewCaseEvent.resolveCaseSuccessful))));
  }

  deleteCase(Case caze) {
    emit(state.copyWith(event: ViewCaseEvent.loading));
    _caseRepository.resolveCase(caze).then((value) => emit(state.copyWith(
        event: value.fold((l) => ViewCaseEvent.deleteCaseFailed,
            (r) => ViewCaseEvent.deleteCaseSuccessful))));
  }
}
