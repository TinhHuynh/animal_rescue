import 'package:freezed_annotation/freezed_annotation.dart';

import '../value_objects/value_object.dart';

part 'location.freezed.dart';

@freezed
abstract class Location with _$Location {
  const factory Location({
    required Latitude latitude,
    required Longitude longitude,
  }) = _Location;

   factory Location.double({
    required double latitude,
    required double longitude,
  }) => Location(latitude: Latitude(latitude), longitude: Longitude(longitude));

   const Location._();

   bool get isValid => latitude.isValid() && longitude.isValid();
}
