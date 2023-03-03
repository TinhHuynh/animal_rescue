import 'package:dartz/dartz.dart';

import '../../core/failures.dart';
import '../../core/value_objects.dart';
import '../../core/value_validators.dart';


class MessageContent extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory MessageContent(String input) {
    return MessageContent._(
      validateStringNotEmpty(input),
    );
  }
  const MessageContent._(this.value);
}

class MessageDate extends ValueObject<DateTime> {
  @override
  final Either<ValueFailure<DateTime>, DateTime> value;

  factory MessageDate(DateTime input) {
    return MessageDate._(
      validateDateTime(input),
    );
  }
  const MessageDate._(this.value);
}

