import 'package:animal_rescue/di/get_it.dart';
import 'package:animal_rescue/extensions/any_x.dart';
import 'package:animal_rescue/extensions/context_x.dart';
import 'package:animal_rescue/gen/assets.gen.dart';
import 'package:animal_rescue/gen/colors.gen.dart';
import 'package:animal_rescue/utils/keyboard_utils.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../routes/app_router.dart';
import '../../../../application/auth/login/login_cubit.dart';
import '../../../core/widgets/border_password_text_field.dart';
import '../../../core/widgets/border_text_field.dart';
import '../../../core/widgets/custom_annotated_region.dart';
import '../../../core/widgets/lifecycle_aware.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomAnnotatedRegion(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: LifecycleAware(
          child: BlocProvider(
            create: (context) => getIt<LoginCubit>(),
            child: BlocListener<LoginCubit, LoginState>(
                listener: (context, state) async {
              if (state.event.isSuccess) {
                await Future.delayed(const Duration(seconds: 1));
                context.router.popForced();
                context.router.push(const HomeRoute());
              }
              toggleLoading(state.event == Event.submitting);
            }, child: Builder(
              builder: (context) {
                return _loginForm(context);
              },
            )),
          ),
        ),
      ),
    );
  }

  _loginForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: ListView(
        children: [
          _image(context),
          _loginText(context),
          const SizedBox(
            height: 24,
          ),
          _emailField(context),
          const SizedBox(
            height: 24,
          ),
          _passwordField(context),
          const SizedBox(
            height: 16,
          ),
          _msgText(context),
          const SizedBox(
            height: 8,
          ),
          _loginButton(context),
          const SizedBox(
            height: 24,
          ),
          _registerText(context),
          const SizedBox(
            height: 24,
          ),
        ],
      ),
    );
  }

  _image(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: Assets.images.imageSplash.image(
          width: context.screenWidth * 0.8, height: context.screenHeight * 0.3),
    );
  }

  _loginText(BuildContext context) {
    return Text(
      context.s.login,
      style: const TextStyle(
        color: ColorName.brand,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  _emailField(BuildContext context) {
    return BorderTextField(
      keyboardType: TextInputType.emailAddress,
      onChanged: (s) => context.read<LoginCubit>().updateEmail(s),
      labelText: context.s.email,
    );
  }

  _passwordField(BuildContext context) {
    return BorderPasswordTextField(
      onChanged: (s) => context.read<LoginCubit>().updatePassword(s),
      labelText: context.s.password,
    );
  }

  _msgText(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) => state.loginOption.fold(
          () => const SizedBox(),
          (a) => a.fold(
              (l) => Text(
                    l.maybeWhen(
                        orElse: () => '',
                        invalidEmailAndPasswordCombination: () =>
                            context.s.invalid_email_password,
                        serverError: () => context.s.failed_to_login),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
              (r) => Text(
                    context.s.logged_in_successfully,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: ColorName.brand),
                  ))),
      buildWhen: (_, s) => s.canRebuild,
    );
  }

  _loginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        KeyboardUtils.hideKeyboard();
        context.read<LoginCubit>().login();
      },
      child: Text(context.s.login),
    );
  }

  _registerText(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          context.s.new_to_animal_rescue,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.black),
        ),
        const SizedBox(width: 4),
        GestureDetector(
          onTap: () {
            context.router.push(const RegisterRoute());
          },
          child: Text(
            context.s.register_now,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: ColorName.brand, decoration: TextDecoration.underline),
          ),
        ),
      ],
    );
  }
}
