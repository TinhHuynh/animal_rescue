import 'package:dartz/dartz.dart';

import '../../core/failures.dart';
import '../../core/value_objects.dart';
import '../../core/value_validators.dart';

class Latitude extends ValueObject<double> {
  @override
  final Either<ValueFailure<double>, double> value;

  factory Latitude(double input) {
    return Latitude._(
      validateLatitude(input),
    );
  }
  const Latitude._(this.value);
}

class Longitude extends ValueObject<double> {
  @override
  final Either<ValueFailure<double>, double> value;

  factory Longitude(double input) {
    return Longitude._(
      validateLongitude(input),
    );
  }
  const Longitude._(this.value);
}