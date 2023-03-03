import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

@freezed
class ChatFailure with _$ChatFailure {
  const factory ChatFailure.failedToSubmitMessage() = FailedToSubmitMessage;
  const factory ChatFailure.failedToLoadMessages() = FailedToLoadMessages;
}
