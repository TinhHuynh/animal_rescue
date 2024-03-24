import 'package:animal_rescue/arch/domain/case/value_objects/value_object.dart';
import 'package:animal_rescue/arch/presentation/case/create_case/widgets/photo_list.dart';
import 'package:animal_rescue/extensions/context_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../application/case/create_case/create_case_cubit.dart';

class AddPhotoSection extends StatelessWidget {
  const AddPhotoSection({super.key, required this.onPhotoListUpdated});

  final Function(List<CaseLocalPhoto>) onPhotoListUpdated;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.s.add_photos,
        ),
        const SizedBox(
          height: 8,
        ),
        PhotoList(onPhotoAdded: (l, _) {
          onPhotoListUpdated(l);
        }, onPhotoRemoved: (l, _) {
          onPhotoListUpdated(l);
        }),
        const SizedBox(
          height: 4,
        ),
        _photoMessage()
      ],
    );
  }

  _photoMessage() {
    return BlocBuilder<CreateCaseCubit, CreateCaseState>(
        buildWhen: (_, state) => state.maybeWhen(
            orElse: () => false,
            submitting: () => true,
            submitFailed: (e) => e.maybeWhen(
                orElse: () => false,
                invalidPhoto: () => true,
                missingPhoto: () => true,
                moreThan3Photos: () => true)),
        builder: (context, state) {
          return state.maybeWhen(
              orElse: () => const SizedBox(),
              submitFailed: (e) => e.maybeWhen(
                  orElse: () => const SizedBox(),
                  invalidPhoto: () => Text(context.s.invalid_photo,
                      style: const TextStyle(color: Colors.red)),
                  missingPhoto: () => Text(context.s.missing_photo,
                      style: const TextStyle(color: Colors.red)),
                  moreThan3Photos: () => Text(
                      context.s.more_than_3_photos_are_not_allowed,
                      style: const TextStyle(color: Colors.red))));
        });
  }
}
