import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/case/failures/failure.dart';
import '../../../domain/case/repositories/case_repository.dart';
import '../../../domain/case/value_objects/value_object.dart';
import '../../../domain/core/value_objects.dart';
import '../../../domain/location/entities/location.dart';

part 'create_case_cubit.freezed.dart';

part 'create_case_state.dart';

class CreateCaseCubit extends Cubit<CreateCaseState> {
  final CaseRepository _caseRepository;

  CreateCaseCubit(this._caseRepository) : super(CreateCaseState.initial());

  Future<void> submit(
      Location location,
      CaseTitle title,
      CaseDescription description,
      CaseAddress address,
      List3<CaseLocalPhoto> photos) async {
    emit(CreateCaseState.submitting());
    if (!_checkValid(location, title, description, address, photos)) {
      return;
    }
    final result = await _caseRepository.createCase(
        location, title, description, address, photos);
    emit(result.fold((l) => CreateCaseState.submitFailed(l),
        (r) => CreateCaseState.submitSuccess(r)));
  }

  bool _checkValid(
      Location location,
      CaseTitle title,
      CaseDescription description,
      CaseAddress address,
      List3<CaseLocalPhoto> photos) {
    if (!location.isValid) {
      emit(CreateCaseState.submitFailed(const CaseFailure.invalidLocation()));
      return false;
    }
    if (!title.isValid()) {
      emit(CreateCaseState.submitFailed(const CaseFailure.invalidTitle()));
      return false;
    }
    if (!description.isValid()) {
      emit(
          CreateCaseState.submitFailed(const CaseFailure.invalidDescription()));
      return false;
    }
    if (!address.isValid()) {
      emit(CreateCaseState.submitFailed(const CaseFailure.invalidAddress()));
      return false;
    }
    if (photos.isEmpty) {
      emit(CreateCaseState.submitFailed(const CaseFailure.missingPhoto()));
      return false;
    } else {
      photos.value.fold((l) {
        emit(CreateCaseState.submitFailed(const CaseFailure.missingPhoto()));
        return false;
      }, (r) {
        if (r.any((element) => !element.isValid() == true)) {
          emit(CreateCaseState.submitFailed(const CaseFailure.invalidPhoto()));
          return false;
        }
      });
    }
    return true;
  }
}
