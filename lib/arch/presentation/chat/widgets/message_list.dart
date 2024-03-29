import 'package:animal_rescue/extensions/context_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../gen/colors.gen.dart';
import '../../../application/chat/chat_cubit.dart';
import '../../../domain/chat/entities/message.dart';
import '../../../domain/chat/value_objects/value_object.dart';
import '../../../domain/core/value_objects.dart';
import 'my_message.dart';
import 'other_message.dart';

class MessageList extends StatefulWidget {
  final UniqueId caseId;

  const MessageList({super.key, required this.caseId});

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  final PagingController<MessageDate?, Message> _pagingController =
      PagingController(firstPageKey: null);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: BlocListener<ChatCubit, ChatState>(
      listenWhen: (_, state) => state.maybeWhen(
          orElse: () => false,
          appendPage: (_) => true,
          appendLastPage: (_) => true,
          loadPageFailed: (_) => true,
          newMessage: (_) => true),
      listener: (context, state) {
        state.maybeWhen(
            orElse: () {},
            loadPageFailed: (_) => _pagingController.error =
                Exception(context.s.failed_to_load_messages),
            appendPage: (p) => _appendList(p),
            appendLastPage: (p) => _appendList(p),
            newMessage: (message) => _addNewMessage(message));
      },
      child: Container(
        color: ColorName.brand.withOpacity(0.4),
        child: PagedListView<MessageDate?, Message>.separated(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          pagingController: _pagingController,
          reverse: true,
          separatorBuilder: (context, index) => const SizedBox(
            height: 16,
          ),
          builderDelegate: PagedChildBuilderDelegate(
              firstPageErrorIndicatorBuilder: (ctx) => const SizedBox(),
              newPageErrorIndicatorBuilder: (ctx) => const SizedBox(),
              noItemsFoundIndicatorBuilder: (ctx) => _noItemFoundWidget(ctx),
              itemBuilder: (ctx, item, index) =>
                  ctx.read<ChatCubit>().isMyMessage(item)
                      ? MyMessage(
                          message: item,
                        )
                      : OtherMessage(
                          message: item,
                        )),
        ),
      ),
    ));
  }

  void _fetchPage(MessageDate? pageKey) {
    if (mounted) {
      context.read<ChatCubit>().getMessagesFor(widget.caseId, pageKey);
    }
  }

  _appendList(PagingData data) {
    if (data.nextItemKey != null) {
      _pagingController.appendPage(data.items, data.nextItemKey);
    } else {
      _pagingController.appendLastPage(data.items);
    }
  }

  _addNewMessage(Message? newMessage) {
    if (newMessage == null) return;
    _pagingController.addFirstItem(newMessage);
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  _noItemFoundWidget(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(
            height: 32,
          ),
          Text(
            context.s.no_message_here,
            style: context.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            context.s.you_can_start_discussion,
            style: context.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

extension PagingControllerX<K, T> on PagingController<K, T> {
  addFirstItem(T newItem) {
    final previousItems = value.itemList ?? [];
    final itemList = [newItem] + previousItems;
    value = PagingState(itemList: itemList);
  }
}
