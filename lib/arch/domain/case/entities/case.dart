import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/value_objects.dart';
import '../../location/value_objects/value_object.dart';
import '../enums/case_status.dart';
import '../value_objects/value_object.dart';

part 'case.freezed.dart';

@freezed
class Case with _$Case {
  const factory Case({
    required UniqueId id,
    required UniqueId userId,
    required CaseTitle title,
    required CaseDescription description,
    required CaseAddress address,
    required Latitude latitude,
    required Longitude longitude,
    required List3<Url> photos,
    required CaseStatus status,
  }) = _Case;
}

extension CaseExtension on Case {
  bool get isActive => status == CaseStatus.active;
}
