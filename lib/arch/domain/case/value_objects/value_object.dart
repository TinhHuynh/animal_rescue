import 'package:dartz/dartz.dart';

import '../../core/failures.dart';
import '../../core/value_objects.dart';
import '../../core/value_validators.dart';


class CaseTitle extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory CaseTitle(String input) {
    return CaseTitle._(
      validateStringNotEmpty(input),
    );
  }
  const CaseTitle._(this.value);
}

class CaseDescription extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory CaseDescription(String input) {
    return CaseDescription._(
      validateStringNotEmpty(input),
    );
  }
  const CaseDescription._(this.value);
}

class CaseAddress extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory CaseAddress(String input) {
    return CaseAddress._(
      validateStringNotEmpty(input),
    );
  }
  const CaseAddress._(this.value);
}

class CaseLocalPhoto extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory CaseLocalPhoto(String input) {
    return CaseLocalPhoto._(
      validateFilePath(input),
    );
  }
  const CaseLocalPhoto._(this.value);
}


class List3<T> extends ValueObject<List<T>> {
  @override
  final Either<ValueFailure<List<T>>, List<T>> value;

  static const maxLength = 3;

  factory List3(List<T> input) {
    return List3._(
      validateMaxListLength(input, maxLength),
    );
  }

  const List3._(this.value);

  int get length {
    return value.getOrElse(() => List.empty()).length;
  }

  bool get isFull {
    return length == maxLength;
  }

  bool get isEmpty {
    return length == 0;
  }
}


