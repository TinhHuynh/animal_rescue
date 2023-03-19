import 'package:animal_rescue/arch/domain/case/value_objects/value_object.dart';
import 'package:animal_rescue/arch/domain/core/value_objects.dart';
import 'package:animal_rescue/arch/presentation/case/create_case/widgets/add_photo.dart';
import 'package:animal_rescue/extensions/any_x.dart';
import 'package:animal_rescue/extensions/context_x.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../di/get_it.dart';
import '../../../../../routes/app_router.dart';
import '../../../../../utils/keyboard_utils.dart';
import '../../../../application/case/create_case/create_case_cubit.dart';
import '../../../../domain/location/entities/location.dart';
import '../../../core/widgets/border_text_field.dart';
import '../../../core/widgets/lifecycle_aware.dart';

class CreateCasePage extends StatefulWidget {
  const CreateCasePage({Key? key, required this.location}) : super(key: key);

  final Location location;

  static show(BuildContext context, Location location) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) {
          return BlocProvider<CreateCaseCubit>(
            create: (context) => getIt<CreateCaseCubit>(),
            child: CreateCasePage(
              location: location,
            ),
          );
        });
  }

  @override
  State<CreateCasePage> createState() => _CreateCasePageState();
}

class _CreateCasePageState extends State<CreateCasePage> {
  String title = "";
  String description = "";
  String address = "";
  List<CaseLocalPhoto> photos = [];

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
                    toggleLoading(state.maybeWhen(
                        orElse: () => false, submitting: () => true));
                    state.maybeWhen(
                      orElse: () {},
                      submitSuccess: (r) {
                        showToast(
                            context.s.the_case_has_been_created_successfully);
                        _goToViewCase(context, r);
                        context.navigator.pop();
                      },
                      submitFailed: (e) {
                        e.maybeWhen(
                            orElse: () {},
                            failedToCreateCase: () {
                              showError(
                                  context, context.s.failed_to_create_case);
                            });
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
        style: context.theme.textTheme.headlineSmall
            ?.copyWith(fontWeight: FontWeight.bold));
  }

  _titleField(BuildContext context) {
    return BlocBuilder<CreateCaseCubit, CreateCaseState>(
      buildWhen: (_, state) => state.maybeWhen(
          orElse: () => false,
          submitting: () => true,
          submitFailed: (e) =>
              e.maybeWhen(orElse: () => false, invalidTitle: () => true)),
      builder: (context, state) {
        return BorderTextField(
            keyboardType: TextInputType.text,
            onChanged: (s) => title = s,
            labelText: context.s.title,
            errorText: state.maybeWhen(
                orElse: () => null,
                submitFailed: (e) => e.maybeWhen(
                    orElse: () => null,
                    invalidPhoto: () => context.s.invalid_title)));
      },
    );
  }

  _descriptionField(BuildContext context) {
    return BlocBuilder<CreateCaseCubit, CreateCaseState>(
      buildWhen: (_, state) => state.maybeWhen(
          orElse: () => false,
          submitting: () => true,
          submitFailed: (e) =>
              e.maybeWhen(orElse: () => false, invalidDescription: () => true)),
      builder: (context, state) {
        return BorderTextField(
            keyboardType: TextInputType.multiline,
            onChanged: (s) => description = s,
            maxLines: 5,
            labelText: context.s.description,
            errorText: state.maybeWhen(
                orElse: () => null,
                submitFailed: (e) => e.maybeWhen(
                    orElse: () => null,
                    invalidDescription: () => context.s.invalid_description)));
      },
    );
  }

  _addressField(BuildContext context) {
    return BlocBuilder<CreateCaseCubit, CreateCaseState>(
      buildWhen: (_, state) => state.maybeWhen(
          orElse: () => false,
          submitting: () => true,
          submitFailed: (e) =>
              e.maybeWhen(orElse: () => false, invalidAddress: () => true)),
      builder: (context, state) {
        return BorderTextField(
            keyboardType: TextInputType.streetAddress,
            onChanged: (s) => address = s,
            labelText: context.s.address,
            errorText: state.maybeWhen(
                orElse: () => null,
                submitFailed: (e) => e.maybeWhen(
                    orElse: () => null,
                    invalidAddress: () => context.s.invalid_address)));
      },
    );
  }

  _addPhotoSection(BuildContext context) {
    return AddPhotoSection(onPhotoListUpdated: (l) => photos = l);
  }

  _submitButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        KeyboardUtils.hideKeyboard();
        context.read<CreateCaseCubit>().submit(
            widget.location,
            CaseTitle(title),
            CaseDescription(description),
            CaseAddress(address),
            List3(photos));
      },
      child: Text(context.s.submit),
    );
  }

  void _goToViewCase(BuildContext context, UniqueId id) {
    context.pushRoute(ViewCaseRoute(caseId: id));
  }
}
