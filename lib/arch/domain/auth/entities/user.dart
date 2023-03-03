import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/value_objects.dart';
import '../value_objects/value_object.dart';

part 'user.freezed.dart';

@freezed
abstract class User with _$User {
  const factory User({
    required UniqueId uid,
    required EmailAddress email,
    required Username username,
    @Default(null) Url? avatarUrl,
  }) = _User;
}