import 'package:animal_rescue/arch/domain/auth/value_objects/value_object.dart';
import 'package:animal_rescue/arch/presentation/auth/register/widgets/user_avatar.dart';
import 'package:animal_rescue/di/get_it.dart';
import 'package:animal_rescue/extensions/any_x.dart';
import 'package:animal_rescue/extensions/context_x.dart';
import 'package:animal_rescue/gen/colors.gen.dart';
import 'package:animal_rescue/utils/keyboard_utils.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../application/auth/register/register_cubit.dart';
import '../../../core/widgets/border_password_text_field.dart';
import '../../../core/widgets/border_text_field.dart';
import '../../../core/widgets/custom_annotated_region.dart';
import '../../../core/widgets/lifecycle_aware.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? avatarPath;
  String username = '';
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return CustomAnnotatedRegion(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: LifecycleAware(
          child: BlocProvider(
            create: (context) => getIt<RegisterCubit>(),
            child: BlocListener<RegisterCubit, RegisterState>(
              listener: (context, state) async {
                toggleLoading(state.maybeWhen(
                    orElse: () => false, submitting: () => true));
                state.maybeWhen(
                    orElse: () {},
                    success: () async {
                      final router = context.router;
                      await Future.delayed(const Duration(seconds: 3));
                      router.navigateBack();
                    });
              },
              child: Padding(
                padding: EdgeInsets.only(top: context.mediaQuery.padding.top),
                child: Stack(
                  children: [_registerForm(), _backIcon(context)],
                ),
              ),
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

  _usernameField(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
        builder: (ctx, state) => BorderTextField(
              keyboardType: TextInputType.text,
              onChanged: (s) => username = s,
              labelText: context.s.username,
              errorText: state.whenOrNull(
                  error: (e) => e.whenOrNull(
                      invalidUsername: () => context.s.invalid_username)),
            ));
  }

  _emailField(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
        builder: (ctx, state) => BorderTextField(
              keyboardType: TextInputType.emailAddress,
              onChanged: (s) => email = s,
              labelText: context.s.email,
              errorText: state.whenOrNull(
                  error: (e) => e.whenOrNull(
                      invalidEmail: () => context.s.invalid_email)),
            ));
  }

  _passwordField(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
        builder: (ctx, state) => BorderPasswordTextField(
            onChanged: (s) => password = s,
            labelText: context.s.password,
            errorText: state.whenOrNull(
                error: (e) => e.whenOrNull(
                    invalidPassword: () => context.s.invalid_password))));
  }

  _msgText(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
        builder: (ctx, state) => state.maybeWhen(
            orElse: () => const SizedBox(),
            error: (e) => Text(
                  e.maybeWhen(
                      orElse: () => '',
                      emailAlreadyInUse: () => context.s.email_already_used,
                      serverError: () => context.s.failed_to_register),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
            success: () => Text(
                  context.s.logged_in_successfully,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: ColorName.brand),
                )));
  }

  _registerButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        KeyboardUtils.hideKeyboard();
        context.read<RegisterCubit>().register(
            avatarPath == null ? null : UserAvatar(avatarPath!),
            Username(username),
            EmailAddress(email),
            StrictPassword(password));
      },
      child: Text(context.s.register),
    );
  }

  _registerForm() {
    return Builder(builder: (context) {
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
          _userAvatar(context),
          const SizedBox(
            height: 16,
          ),
          _usernameField(context),
          const SizedBox(
            height: 16,
          ),
          _emailField(context),
          const SizedBox(
            height: 16,
          ),
          _passwordField(context),
          const SizedBox(
            height: 16,
          ),
          _msgText(context),
          const SizedBox(
            height: 8,
          ),
          _registerButton(context),
          const SizedBox(
            height: 24,
          ),
        ],
      );
    });
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

  _userAvatar(BuildContext context) {
    return UserAvatarWidget(onImagePathChanged: (p) => avatarPath = p);
  }
}
