import 'package:animal_rescue/converters/server_timestamp_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/auth/entities/user.dart';
import '../../../domain/chat/entities/message.dart';
import '../../../domain/chat/value_objects/value_object.dart';
import '../../../domain/core/value_objects.dart';

part 'message_dto.freezed.dart';

part 'message_dto.g.dart';

@freezed
class MessageDto with _$MessageDto {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory MessageDto({
    required String id,
    required String userId,
    required String caseId,
    required String content,
    @ServerTimestampConverter() @Default(null) DateTime? createdDate,
  }) = _MessageDto;

  factory MessageDto.fromJson(Map<String, dynamic> json) =>
      _$MessageDtoFromJson(json);

  const MessageDto._();

  Message toDomain(User user) {
    return Message(
        id: UniqueId.fromUniqueString(id),
        user: user,
        caseId: UniqueId.fromUniqueString(caseId),
        content: MessageContent(content),
        createdDate: MessageDate(createdDate ?? DateTime.now()));
  }
}
