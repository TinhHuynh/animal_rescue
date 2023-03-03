
import 'package:dartz/dartz.dart';

import '../../../domain/location/entities/location.dart';
import '../../../domain/location/failures/location_failure.dart' as failure;
import '../../../domain/location/repositories/location_repository.dart';
import '../../core/location/location_helper.dart' as l;

class LocationRepositoryImpl implements LocationRepository {
  final l.LocationHelper _locationHelper;

  LocationRepositoryImpl(this._locationHelper);

  @override
  Future<Either<failure.LocationFailure, Location>> getCurrentLocation() async {
    try {
      final location = await _locationHelper.getCurrentPosition();
      return right(
          Location.double(latitude: location.lat, longitude: location.long));
    } on l.ServiceNotEnabled {
      return left(const failure.LocationFailure.serviceNotEnabled());
    } on l.PermissionDenied {
      return left(const failure.LocationFailure.permissionDenied());
    } on l.PermissionDeniedForever {
      return left(const failure.LocationFailure.permissionDeniedForever());
    }
  }
}
