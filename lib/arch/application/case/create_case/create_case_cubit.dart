import 'package:dartz/dartz.dart';
import 'package:enum_annotation/enum_annotation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/case/failures/failure.dart';
import '../../../domain/case/repositories/case_repository.dart';
import '../../../domain/case/value_objects/value_object.dart';
import '../../../domain/core/value_objects.dart';
import '../../../domain/location/entities/location.dart';

part 'create_case_cubit.freezed.dart';

part 'create_case_cubit.g.dart';

part 'create_case_state.dart';

class CreateCaseCubit extends Cubit<CreateCaseState> {
  final CaseRepository _caseRepository;

  CreateCaseCubit(this._caseRepository) : super(CreateCaseState.initial());

  updateTitle(String title) {
    emit(state.copyWith(
        event: CreateCaseEvent.inputting, title: CaseTitle(title)));
  }

  updateDescription(String description) {
    emit(state.copyWith(
        event: CreateCaseEvent.inputting,
        description: CaseDescription(description)));
  }

  updateAddress(String address) {
    emit(state.copyWith(
        event: CreateCaseEvent.inputting, address: CaseAddress(address)));
  }

  addPhoto(String localPath) {
    state.photos.value.fold((l) => () {}, (r) {
      final list = List.of(r);
      list.add(CaseLocalPhoto(localPath));
      emit(
          state.copyWith(event: CreateCaseEvent.addPhoto, photos: List3(list)));
    });
  }

  removePhoto(String localPath) {
    state.photos.value.fold((l) => () {}, (r) {
      try {
        final list = List.of(r);
        list.removeWhere((e) => e.getOrCrash() == localPath);
        emit(state.copyWith(
            event: CreateCaseEvent.removePhoto, photos: List3(list)));
      } catch (e) {
        emit(state.copyWith(
            event: CreateCaseEvent.inputFailed,
            inputOption:
                Some(left(const CaseFailure.failedToRemovePhoto()))));
      }
    });
  }

  Future<void> submit() async {
    emit(state.copyWith(event: CreateCaseEvent.submitting));
    if (!_checkValid()) {
      return;
    }
    final result = await _caseRepository.createCase(state.location, state.title,
        state.description, state.address, state.photos);
    emit(result.fold(
        (l) => state.copyWith(
            event: CreateCaseEvent.submitFailed,
            submitOption: some(left(l))),
        (r) => state.copyWith(
            event: CreateCaseEvent.submitSuccess,
            submitOption: some(right(r)))));
  }

  bool _checkValid() {
    if (!state.location.isValid) {
      emit(state.onError(const CaseFailure.invalidLocation()));
      return false;
    }
    if (!state.title.isValid()) {
      emit(state.onError(const CaseFailure.invalidTitle()));
      return false;
    }
    if (!state.description.isValid()) {
      emit(state.onError(const CaseFailure.invalidDescription()));
      return false;
    }
    if (!state.address.isValid()) {
      emit(state.onError(const CaseFailure.invalidAddress()));
      return false;
    }
    if (state.photos.isEmpty) {
      emit(state.onError(const CaseFailure.missingPhoto()));
      return false;
    } else {
      state.photos.value.fold((l) {
        emit(state.onError(const CaseFailure.moreThan3Photos()));
        return false;
      }, (r) {
        if (r.any((element) => !element.isValid() == true)) {
          emit(state.onError(const CaseFailure.invalidPhoto()));
          return false;
        }
      });
    }
    return true;
  }

  setLocation(Location location) {
    emit(state.copyWith(location: location));
  }
}
