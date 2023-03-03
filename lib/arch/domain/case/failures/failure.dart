import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

@freezed
class CaseFailure with _$CaseFailure {
  const factory CaseFailure.failedToLoadCase() = FailedToLoadCase;
  const factory CaseFailure.failedToRemovePhoto() = FailedToRemovePhoto;
  const factory CaseFailure.failedToCreateCase() = FailedToCreateCase;
  const factory CaseFailure.failedToResolveCase() = FailedToResolveCase;
  const factory CaseFailure.failedToDeleteCase() = FailedToDeleteCase;
  const factory CaseFailure.invalidLocation() = InvalidLocation;
  const factory CaseFailure.invalidTitle() = InvalidTitle;
  const factory CaseFailure.invalidDescription() = InvalidDescription;
  const factory CaseFailure.invalidAddress() = InvalidAddress;
  const factory CaseFailure.moreThan3Photos() = MoreThan3Photos;
  const factory CaseFailure.missingPhoto() = MissingPhoto;
  const factory CaseFailure.invalidPhoto() = InvalidPhoto;
}