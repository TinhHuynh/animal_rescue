import 'dart:io';

import 'package:dartz/dartz.dart';

import 'failures.dart';

Either<ValueFailure<String>, String> validateStringNotEmpty(String input) {
  if (input.isNotEmpty) {
    return right(input);
  } else {
    return left(ValueFailure.empty(failedValue: input));
  }
}

Either<ValueFailure<String>, String> validateEmailAddress(String input) {
  const emailRegex =
      r"""^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+""";
  if (RegExp(emailRegex).hasMatch(input)) {
    return right(input);
  } else {
    return left(ValueFailure.invalidEmail(failedValue: input));
  }
}

Either<ValueFailure<String>, String> validatePassword(String input) {
  if (input.length >= 8) {
    return right(input);
  } else {
    return left(ValueFailure.invalidPassword(failedValue: input));
  }
}

Either<ValueFailure<String>, String> validateFilePath(String input) {
  if (File(input).existsSync()) {
    return right(input);
  } else {
    return left(ValueFailure.invalidFilePath(failedValue: input));
  }
}

Either<ValueFailure<String>, String> validateUrl(String input) {
  if (Uri.parse(input).isAbsolute) {
    return right(input);
  } else {
    return left(ValueFailure.invalidUrl(failedValue: input));
  }
}

Either<ValueFailure<List<T>>, List<T>> validateMaxListLength<T>(
  List<T> input,
  int maxLength,
) {
  if (input.length <= maxLength) {
    return right(input);
  } else {
    return left(ValueFailure.listTooLong(
      failedValue: input,
      max: maxLength,
    ));
  }
}

Either<ValueFailure<double>, double> validateLatitude<T>(double latitude) {
  return (latitude.isFinite && latitude.abs() <= 90)
      ? right(latitude)
      : left(ValueFailure.invalidLatitude(failedValue: latitude));
}

Either<ValueFailure<double>, double> validateLongitude<T>(double longitude) {
  return (longitude.isFinite && longitude.abs() <= 180)
      ? right(longitude)
      : left(ValueFailure.invalidLatitude(failedValue: longitude));
}

Either<ValueFailure<DateTime>, DateTime> validateDateTime<T>(DateTime dateTime) {
  return (dateTime.millisecondsSinceEpoch > 0)
      ? right(dateTime)
      : left(ValueFailure.invalidDateTime(failedValue: dateTime));
}

