
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/location/entities/location.dart';

part 'location_dto.freezed.dart';

part 'location_dto.g.dart';

@freezed
class LocationDto with _$LocationDto {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory LocationDto({
    required double lat,
    required double long,
  }) = _LocationDto;

  factory LocationDto.fromJson(Map<String, dynamic> json) =>
      _$LocationDtoFromJson(json);

  const LocationDto._();

  factory LocationDto.fromDomain(Location location) => LocationDto(
      lat: location.latitude.getOrCrash(),
      long: location.longitude.getOrCrash());
}
