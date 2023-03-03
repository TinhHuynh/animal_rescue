import 'package:animal_rescue/extensions/context_x.dart';
import 'package:animal_rescue/gen/assets.gen.dart';
import 'package:flutter/material.dart';

import '../../../../gen/colors.gen.dart';
import '../../../domain/chat/entities/message.dart';


class OtherMessage extends StatelessWidget {
  final Message message;

  const OtherMessage({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _otherMessage(context);
  }

  _otherMessage(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundImage: message.user.avatarUrl == null
              ? Assets.images.imgUserAvatar.provider()
              : message.user.avatarUrl!.value.fold(
                  (l) => Assets.images.imgUserAvatar.provider(),
                  (r) => NetworkImage(r)),
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(message.user.username.getOrCrash(),
                  style: context.textTheme.titleSmall
                      ?.copyWith(color: Colors.black)),
              const SizedBox(
                height: 4,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: ColorName.brand,
                ),
                padding: const EdgeInsets.all(8),
                child: Text(
                  message.content.getOrCrash(),
                  style: context.textTheme.titleMedium
                      ?.copyWith(color: Colors.white),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
