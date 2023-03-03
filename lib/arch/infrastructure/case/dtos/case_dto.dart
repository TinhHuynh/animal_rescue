import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';

import '../../../../converters/geopoint_converter.dart';
import '../../../domain/case/entities/case.dart';
import '../../../domain/case/enums/case_status.dart';
import '../../../domain/case/value_objects/value_object.dart';
import '../../../domain/core/value_objects.dart';
import '../../../domain/location/value_objects/value_object.dart';

part 'case_dto.freezed.dart';

part 'case_dto.g.dart';

@freezed
class CaseDto with _$CaseDto {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory CaseDto(
      {required String id,
      required String userid,
      required String title,
      required String description,
      required String address,
      required LocationPoint locationPoint,
      required CaseStatus status}) = _CaseDto;

  factory CaseDto.fromJson(Map<String, dynamic> json) =>
      _$CaseDtoFromJson(json);

  const CaseDto._();

  double get latitude => locationPoint.latitude;

  double get longitude => locationPoint.longitude;

  Case toDomain(List3<Url> photos) => Case(
      id: UniqueId.fromUniqueString(id),
      userId: UniqueId.fromUniqueString(userid),
      title: CaseTitle(title),
      description: CaseDescription(description),
      address: CaseAddress(address),
      latitude: Latitude(latitude),
      longitude: Longitude(longitude),
      photos: photos,
      status: status);
}

@freezed
class LocationPoint with _$LocationPoint {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory LocationPoint(
      {required String geohash,
      @GeoPointConverter() required GeoPoint geopoint}) = _LocationPoint;

  factory LocationPoint.fromJson(Map<String, dynamic> json) =>
      _$LocationPointFromJson(json);

  const LocationPoint._();

  factory LocationPoint.fromLatitudeLongitude(
      double latitude, double longitude) {
    GeoFirePoint point = GeoFirePoint(latitude, longitude);
    return LocationPoint(
        geohash: point.hash,
        geopoint: GeoPoint(point.latitude, point.longitude));
  }

  double get latitude => geopoint.latitude;

  double get longitude => geopoint.longitude;
}
