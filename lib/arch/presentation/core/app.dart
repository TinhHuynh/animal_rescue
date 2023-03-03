import 'package:animal_rescue/di/get_it.dart';
import 'package:animal_rescue/routes/app_router.dart';
import 'package:animal_rescue/routes/guards/auth_guard.dart';
import 'package:animal_rescue/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../../../generated/l10n.dart';
import '../../domain/auth/repositories/auth_repository.dart';


class App extends StatelessWidget {
  final _appRouter = AppRouter(authGuard: AuthGuard(getIt<AuthRepository>()));

  App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      routerDelegate: _appRouter.delegate(),
      routeInformationParser: _appRouter.defaultRouteParser(),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: EasyLoading.init(),
    );
  }
}
