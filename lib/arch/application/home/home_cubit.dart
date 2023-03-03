import 'package:dartz/dartz.dart';
import 'package:enum_annotation/enum_annotation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/case/entities/case.dart';
import '../../domain/case/enums/case_status.dart';
import '../../domain/case/repositories/case_repository.dart';
import '../../domain/location/entities/location.dart';
import '../../domain/location/failures/location_failure.dart';
import '../../domain/location/repositories/location_repository.dart';

part 'home_cubit.freezed.dart';

part 'home_cubit.g.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final LocationRepository _locationRepository;
  final CaseRepository _caseRepository;

  HomeCubit(this._locationRepository, this._caseRepository)
      : super(HomeState.initial());

  init() async {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      emit(state.copyWith(event: HomeEvent.loading));
      final locationResult = await _locationRepository.getCurrentLocation();
      emit(locationResult.fold(
          (l) => state.copyWith(
              event: HomeEvent.locationError,
              failureOrLocation: some(left(l))), (r) {
        return state.copyWith(
            event: HomeEvent.locationUpdated,
            failureOrLocation: some(right(r)));
      }));
    });
  }

  Stream<List<Case>> observeNearbyCase(Location location) {
    return _caseRepository.nearByCaseStream(location, 5).map((event) =>
        event.where((element) => element.status == CaseStatus.active).toList());
  }
}
