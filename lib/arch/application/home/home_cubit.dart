import 'package:animal_rescue/arch/domain/auth/failures/auth_failure.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain/auth/repositories/auth_repository.dart';
import '../../domain/case/entities/case.dart';
import '../../domain/case/enums/case_status.dart';
import '../../domain/case/repositories/case_repository.dart';
import '../../domain/location/entities/location.dart';
import '../../domain/location/failures/location_failure.dart';
import '../../domain/location/repositories/location_repository.dart';

part 'home_cubit.freezed.dart';

part 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final LocationRepository _locationRepository;
  final CaseRepository _caseRepository;
  final AuthRepository _authRepository;

  HomeCubit(
      this._locationRepository, this._caseRepository, this._authRepository)
      : super(const HomeState.initial());

  init() async {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      emit(const HomeState.loading());
      await _locationRepository.getCurrentLocation().then((value) => value.fold(
          (l) => emit(HomeState.locationError(l)),
          (r) => emit(HomeState.locationUpdated(r))));
    });
  }

  Stream<List<Case>> observeNearbyCase(Location location) {
    return _caseRepository.nearByCaseStream(location, 5).map((event) =>
        event.where((element) => element.status == CaseStatus.active).toList());
  }

  Future<void> logout() async {
    emit(const HomeState.loading());
    await _authRepository.logout().then((value) {
      value.fold((l) => emit(HomeState.logoutFailed(l)),
          (r) => emit(const HomeState.loggedOut()));
    });
  }
}
