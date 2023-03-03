import 'dart:io';

import 'package:animal_rescue/di/get_it.dart';
import 'package:animal_rescue/extensions/context_x.dart';
import 'package:animal_rescue/gen/assets.gen.dart';
import 'package:animal_rescue/gen/colors.gen.dart';
import 'package:animal_rescue/utils/keyboard_utils.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../application/auth/register/register_cubit.dart';
import '../../../core/dialogs/image_picker.dart';
import '../../../core/widgets/border_password_text_field.dart';
import '../../../core/widgets/border_text_field.dart';
import '../../../core/widgets/custom_annotated_region.dart';
import '../../../core/widgets/lifecycle_aware.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomAnnotatedRegion(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: LifecycleAware(
          child: BlocProvider(
            create: (context) => getIt<RegisterCubit>(),
            child: BlocConsumer<RegisterCubit, RegisterState>(
              buildWhen: (_, state) => true,
              listener: (context, state) async {
                if (state.event.isSuccess) {
                  await Future.delayed(const Duration(seconds: 3));
                  context.router.navigateBack();
                }
              },
              builder: (context, state) {
                return Padding(
                  padding: EdgeInsets.only(top: context.mediaQuery.padding.top),
                  child: Stack(
                    children: [
                      _registerForm(context, state),
                      _backIcon(context)
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  _registerText(BuildContext context) {
    return Text(
      context.s.register,
      style: const TextStyle(
        color: ColorName.brand,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  _usernameField(BuildContext context, RegisterState state) {
    return BorderTextField(
      keyboardType: TextInputType.text,
      onChanged: (s) => context.read<RegisterCubit>().updateUsername(s),
      labelText: context.s.username,
      errorText: state.failureOrSuccessOption.fold(
          () => null,
          (a) => a.fold(
              (l) => l.maybeWhen(
                  orElse: () => null,
                  invalidUsername: () => context.s.invalid_username),
              (r) => null)),
    );
  }

  _emailField(BuildContext context, RegisterState state) {
    return BorderTextField(
        keyboardType: TextInputType.emailAddress,
        onChanged: (s) => context.read<RegisterCubit>().updateEmail(s),
        labelText: context.s.email,
        errorText: state.failureOrSuccessOption.fold(
            () => null,
            (a) => a.fold(
                (l) => l.maybeWhen(
                    orElse: () => null,
                    invalidEmail: () => context.s.invalid_email),
                (r) => null)));
  }

  _passwordField(BuildContext context, RegisterState state) {
    return BorderPasswordTextField(
        onChanged: (s) => context.read<RegisterCubit>().updatePassword(s),
        labelText: context.s.password,
        helperText: context.s.password_hint,
        errorText: state.failureOrSuccessOption.fold(
            () => null,
            (a) => a.fold(
                (l) => l.maybeWhen(
                    orElse: () => null,
                    invalidPassword: () => context.s.password_hint),
                (r) => null)));
  }

  _msgText(BuildContext context, RegisterState state) {
    return state.failureOrSuccessOption.fold(
        () => const SizedBox(),
        (a) => a.fold(
            (l) => Text(
                  l.maybeWhen(
                      orElse: () => '',
                      emailAlreadyInUse: () => context.s.email_already_used,
                      serverError: () => context.s.failed_to_register),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
            (r) => Text(
                  context.s.logged_in_successfully,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: ColorName.brand),
                )));
  }

  _registerButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        KeyboardUtils.hideKeyboard();
        context.read<RegisterCubit>().register();
      },
      child: Text(context.s.register),
    );
  }

  _registerForm(BuildContext context, RegisterState state) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(
          height: 48,
        ),
        _registerText(context),
        const SizedBox(
          height: 24,
        ),
        _userAvatar(context, state),
        const SizedBox(
          height: 16,
        ),
        _usernameField(context, state),
        const SizedBox(
          height: 16,
        ),
        _emailField(context, state),
        const SizedBox(
          height: 16,
        ),
        _passwordField(context, state),
        const SizedBox(
          height: 16,
        ),
        _msgText(context, state),
        const SizedBox(
          height: 8,
        ),
        _registerButton(context),
        const SizedBox(
          height: 24,
        ),
      ],
    );
  }

  _backIcon(BuildContext context) {
    return Positioned(
        top: 0,
        left: 24,
        child: InkWell(
          customBorder: const CircleBorder(),
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      offset: const Offset(0, 0.5))
                ]),
            child: const Icon(
              Icons.arrow_back,
              size: 24,
            ),
          ),
          onTap: () => context.router.pop(),
        ));
  }

  _userAvatar(BuildContext context, RegisterState state) {
    return Center(
      child: GestureDetector(
        onTap: () => _openPhotoDialog(context),
        child: Stack(
          children: [
            state.userAvatar.value.fold(
                (l) =>
                    Assets.images.imgUserAvatar.image(width: 150, height: 150),
                (r) => SizedBox(
                      width: 150,
                      height: 150,
                      child: CircleAvatar(
                        backgroundImage: FileImage(File(r)),
                      ),
                    )),
            const Positioned(
                bottom: 0,
                right: 10,
                child: Icon(
                  Icons.add_a_photo,
                  color: ColorName.brand,
                ))
          ],
        ),
      ),
    );
  }

  _openPhotoDialog(BuildContext context) {
    final cubit = context.read<RegisterCubit>();
    showImagePicker(context, (file) {
      if (file != null) {
        cubit.updateAvatar(file.path);
      }
    });
  }
}
