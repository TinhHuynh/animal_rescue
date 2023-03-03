
import 'dart:io';

import 'package:animal_rescue/extensions/any_x.dart';
import 'package:animal_rescue/extensions/context_x.dart';
import 'package:animal_rescue/extensions/dartz_x.dart';
import 'package:auto_route/auto_route.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../di/get_it.dart';
import '../../../../../gen/colors.gen.dart';
import '../../../../../routes/app_router.dart';
import '../../../../../utils/keyboard_utils.dart';
import '../../../../application/case/create_case/create_case_cubit.dart';
import '../../../../domain/location/entities/location.dart';
import '../../../core/dialogs/image_picker.dart';
import '../../../core/widgets/border_text_field.dart';
import '../../../core/widgets/lifecycle_aware.dart';

class CreateCasePage extends StatelessWidget {
  const CreateCasePage({Key? key}) : super(key: key);

  static show(BuildContext context, Location location) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) {
          return BlocProvider<CreateCaseCubit>(
            create: (context) =>
                getIt<CreateCaseCubit>()..setLocation(location),
            child: const CreateCasePage(),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Wrap(
          children: [
            LifecycleAware(
              child: Padding(
                padding:
                    EdgeInsets.only(top: context.mediaQuery.padding.top + 52),
                child: BlocListener<CreateCaseCubit, CreateCaseState>(
                  listener: (context, state) {
                    state.event.whenOrNull(
                      orElse: () => hideLoading(),
                      submitting: () => showLoading(),
                      submitSuccess: () {
                        hideLoading();
                        showToast(
                            context.s.the_case_has_been_created_successfully);
                        _goToViewCase(context, state);
                        context.navigator.pop();
                      },
                      submitFailed: () {
                        hideLoading();
                        showError(context, context.s.failed_to_create_case);
                      },
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                        top: 24,
                        left: 24,
                        right: 24,
                        bottom: context.mediaQuery.padding.bottom + 24),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))),
                    child: Column(
                      children: [
                        _closeButton(context),
                        _label(context),
                        const SizedBox(height: 24),
                        _titleField(context),
                        const SizedBox(height: 12),
                        _descriptionField(context),
                        const SizedBox(height: 12),
                        _addressField(context),
                        const SizedBox(height: 16),
                        _addPhotoSection(context),
                        const SizedBox(height: 24),
                        _submitButton(context),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _closeButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(Icons.close))
      ],
    );
  }

  _label(BuildContext context) {
    return Text(context.s.create_a_case,
        style: context.theme.textTheme.headline5
            ?.copyWith(fontWeight: FontWeight.bold));
  }

  _titleField(BuildContext context) {
    return BlocBuilder<CreateCaseCubit, CreateCaseState>(
      buildWhen: (_, state) => state.event.isInputFailed,
      builder: (context, state) {
        return BorderTextField(
          keyboardType: TextInputType.text,
          onChanged: context.read<CreateCaseCubit>().updateTitle,
          labelText: context.s.title,
          errorText: state.inputOption.foldDefaultRight(
              (l) => l.maybeWhen(
                  orElse: () => null,
                  invalidTitle: () => context.s.invalid_title),
              () => null),
        );
      },
    );
  }

  _descriptionField(BuildContext context) {
    return BlocBuilder<CreateCaseCubit, CreateCaseState>(
      buildWhen: (_, state) => state.event.isInputFailed,
      builder: (context, state) {
        return BorderTextField(
          keyboardType: TextInputType.multiline,
          onChanged: context.read<CreateCaseCubit>().updateDescription,
          maxLines: 5,
          labelText: context.s.description,
          errorText: state.inputOption.foldDefaultRight(
              (l) => l.maybeWhen(
                  orElse: () => null,
                  invalidDescription: () => context.s.invalid_description),
              () => null),
        );
      },
    );
  }

  _addressField(BuildContext context) {
    return BlocBuilder<CreateCaseCubit, CreateCaseState>(
      buildWhen: (_, state) => state.event.isInputFailed,
      builder: (context, state) {
        return BorderTextField(
          keyboardType: TextInputType.streetAddress,
          onChanged: context.read<CreateCaseCubit>().updateAddress,
          labelText: context.s.address,
          errorText: state.inputOption.foldDefaultRight(
              (l) => l.maybeWhen(
                  orElse: () => null,
                  invalidAddress: () => context.s.invalid_address),
              () => null),
        );
      },
    );
  }

  _addPhotoSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.s.add_photos,
        ),
        const SizedBox(
          height: 8,
        ),
        SizedBox(
          height: 150,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _addPhoto(context),
              _photoList(),
            ],
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        _photoMessage()
      ],
    );
  }

  _addPhoto(BuildContext context) {
    return BlocBuilder<CreateCaseCubit, CreateCaseState>(
      buildWhen: (_, state) => state.event.maybeWhen(
          orElse: () => false,
          addPhoto: () => true,
          removePhoto: () => true,
          inputFailed: () => true),
      builder: (context, state) {
        final color = state.photos.isFull
            ? Colors.grey
            : state.event.isInputFailed
                ? state.inputOption.foldDefaultRight(
                    (l) => l.maybeWhen(
                          orElse: () => ColorName.brand,
                          invalidPhoto: () => Colors.red,
                          missingPhoto: () => Colors.red,
                          moreThan3Photos: () => Colors.red,
                        ),
                    () => ColorName.brand)
                : ColorName.brand;
        return GestureDetector(
          onTap: () => state.photos.isFull ? null : _openImagePicker(context),
          child: DottedBorder(
            color: color,
            strokeWidth: 2,
            child: SizedBox(
              width: 150,
              height: 150,
              child: Icon(
                Icons.add_a_photo,
                size: 75,
                color: color,
              ),
            ),
          ),
        );
      },
    );
  }

  _photoList() {
    return BlocBuilder<CreateCaseCubit, CreateCaseState>(
      buildWhen: (_, state) => state.event.maybeWhen(
        orElse: () => false,
        addPhoto: () => true,
        removePhoto: () => true,
      ),
      builder: (context, state) {
        return Row(
          children: state.photos.value.fold(
              (l) => [const SizedBox()],
              (r) => r
                  .map((e) => e.value
                      .fold((l) => const SizedBox(), (r) => _photo(context, r)))
                  .toList()),
        );
      },
    );
  }

  Widget _photo(BuildContext context, String path) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Stack(
        children: [
          Image.file(File(path), width: 150, height: 150, fit: BoxFit.cover),
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: () => context.read<CreateCaseCubit>().removePhoto(path),
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(
                  Icons.delete_forever,
                  color: ColorName.brand,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _photoMessage() {
    return BlocBuilder<CreateCaseCubit, CreateCaseState>(
        buildWhen: (_, state) => state.event.maybeWhen(
              orElse: () => false,
              inputFailed: () => true,
              addPhoto: () => true,
              removePhoto: () => true,
            ),
        builder: (context, state) {
          return state.event.isInputFailed
              ? state.inputOption.foldDefaultRight(
                  (l) => l.maybeWhen(
                      orElse: () => const SizedBox(),
                      invalidPhoto: () => Text(context.s.invalid_photo,
                          style: const TextStyle(color: Colors.red)),
                      missingPhoto: () => Text(context.s.missing_photo,
                          style: const TextStyle(color: Colors.red)),
                      moreThan3Photos: () => Text(
                          context.s.more_than_3_photos_are_not_allowed,
                          style: const TextStyle(color: Colors.red))),
                  () => const SizedBox(),
                )
              : const SizedBox();
        });
  }

  _submitButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        KeyboardUtils.hideKeyboard();
        context.read<CreateCaseCubit>().submit();
      },
      child: Text(context.s.submit),
    );
  }

  _openImagePicker(BuildContext context) {
    showImagePicker(context, (file) {
      if (file != null) {
        context.read<CreateCaseCubit>().addPhoto(file.path);
      }
    });
  }

  void _goToViewCase(BuildContext context, CreateCaseState state) {
    state.event.whenOrNull(
      submitSuccess: () {
        state.submitOption.foldDefaultLeft(() => null, (r) {
          context.pushRoute(ViewCaseRoute(caseId: r));
        });
      },
    );
  }
}
