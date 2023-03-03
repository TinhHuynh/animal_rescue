import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/value_objects.dart';

part 'photo.freezed.dart';

@freezed
class Photo with _$Photo {
  const factory Photo({
    required Url url
  }) = _Photo;

}