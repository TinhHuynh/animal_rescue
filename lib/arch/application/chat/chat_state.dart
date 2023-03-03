part of 'chat_cubit.dart';

@freezed
class ChatState with _$ChatState {
  const factory ChatState(
      {required ChatEvent event,
      required Option<Either<ChatFailure, Unit>> submitMessageOptions,
      required Option<Either<ChatFailure, PagingData>> loadPageOptions,
      @Default(null) Message? newMessage}) = _ChatState;

  const ChatState._();

  factory ChatState.initial() => ChatState(
      event: ChatEvent.initial,
      submitMessageOptions: none(),
      loadPageOptions: none());
}

@generate
enum ChatEvent {
  initial,
  loading,
  submittingLoading,
  submitMessageSuccess,
  submitMessageFailed,
  loadingPage,
  appendPage,
  appendLastPage,
  loadPageFailed,
  newMessage,
}

class PagingData {
  final List<Message> items;
  MessageDate? nextItemKey;

  PagingData(this.items, {this.nextItemKey});
}
