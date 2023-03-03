import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

@freezed
class ValueFailure<T> with _$ValueFailure<T> {
  const factory ValueFailure.empty({
    required T failedValue,
  }) = Empty<T>;

  const factory ValueFailure.invalidEmail({
    required T failedValue,
  }) = InvalidEmail<T>;

  const factory ValueFailure.invalidPassword({
    required T failedValue,
  }) = InvalidPassword<T>;

  const factory ValueFailure.invalidUrl({
    required T failedValue,
  }) = InvalidUrl<T>;

  const factory ValueFailure.invalidFilePath({
    required T failedValue,
  }) = InvalidFilePath<T>;

  const factory ValueFailure.listTooLong({
    required T failedValue,
    required int max,
  }) = ListTooLong<T>;

  const factory ValueFailure.invalidLatitude({
    required T failedValue,
  }) = InvalidLatitude<T>;

  const factory ValueFailure.invalidLongitude({
    required T failedValue,
  }) = InvalidLongitude<T>;

  const factory ValueFailure.invalidDateTime({
    required T failedValue,
  }) = InvalidDateTime<T>;
}
