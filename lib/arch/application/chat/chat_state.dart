part of 'chat_cubit.dart';

@freezed
class ChatState with _$ChatState {
  const ChatState._();

  factory ChatState.initial() = _Initial;

  factory ChatState.loading() = _Loading;

  factory ChatState.submittingMessageLoading() = _SubmittingMessageLoading;

  factory ChatState.submitMessageSuccess() = _SubmitMessageSuccess;

  factory ChatState.submitMessageFailed(ChatFailure failure) =
      _SubmitMessageFailed;

  factory ChatState.loadingPage() = _LoadingPage;

  factory ChatState.appendPage(PagingData data) = _AppendPage;

  factory ChatState.appendLastPage(PagingData data) = _AppendLastPage;

  factory ChatState.loadPageFailed(ChatFailure failure) = _LoadPageFailed;

  factory ChatState.newMessage(Message message) = _NewMessage;
}

class PagingData {
  final List<Message> items;
  MessageDate? nextItemKey;

  PagingData(this.items, {this.nextItemKey});
}
