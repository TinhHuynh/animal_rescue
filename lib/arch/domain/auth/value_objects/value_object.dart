import 'package:dartz/dartz.dart';

import '../../core/failures.dart';
import '../../core/value_objects.dart';
import '../../core/value_validators.dart';

class EmailAddress extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory EmailAddress(String input) {
    return EmailAddress._(
      validateEmailAddress(input),
    );
  }
  const EmailAddress._(this.value);
}

class Password extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory Password(String input) {
    return Password._(
      validateStringNotEmpty(input),
    );
  }
  const Password._(this.value);

}

class StrictPassword extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory StrictPassword(String input) {
    return StrictPassword._(
      validatePassword(input),
    );
  }
  const StrictPassword._(this.value);
}

class Username extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory Username(String input) {
    return Username._(
      validateStringNotEmpty(input),
    );
  }
  const Username._(this.value);
}

class UserAvatar extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory UserAvatar(String input) {
    return UserAvatar._(
      validateFilePath(input),
    );
  }
  const UserAvatar._(this.value);
}
