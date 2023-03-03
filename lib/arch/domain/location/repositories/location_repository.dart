import 'package:dartz/dartz.dart';

import '../entities/location.dart';
import '../failures/location_failure.dart';

abstract class LocationRepository{
  Future<Either<LocationFailure, Location>> getCurrentLocation();
}