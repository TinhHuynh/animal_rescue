import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/auth/entities/user.dart';
import '../../../domain/auth/value_objects/value_object.dart';
import '../../../domain/core/value_objects.dart';

part 'user_dto.freezed.dart';

part 'user_dto.g.dart';

@freezed
class UserDto with _$UserDto {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory UserDto(
      {required String uid,
      required String email,
      required String username,
      @Default(null) String? avatarUrl}) = _UserDto;

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  const UserDto._();

  factory UserDto.fromDomain(User user) {
    return UserDto(
        uid: user.uid.getOrCrash(),
        email: user.email.getOrCrash(),
        username: user.username.getOrCrash(),
        avatarUrl: user.avatarUrl?.getOrCrash());
  }

  User toDomain() {
    return User(
        uid: UniqueId.fromUniqueString(uid),
        email: EmailAddress(email),
        username: Username(username),
        avatarUrl: avatarUrl == null ? null : Url(avatarUrl!));
  }
}
