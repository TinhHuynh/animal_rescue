import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../auth/entities/user.dart';
import '../../core/value_objects.dart';
import '../value_objects/value_object.dart';

part 'message.freezed.dart';

@freezed
class Message with _$Message {
  const factory Message({
    required UniqueId id,
    required User user,
    required UniqueId caseId,
    required MessageContent content,
    required MessageDate createdDate,
  }) = _Message;
}