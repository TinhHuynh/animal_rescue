import 'package:animal_rescue/di/di.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../arch/domain/core/value_objects.dart';
import '../arch/presentation/auth/login/pages/login_page.dart';
import '../arch/presentation/auth/register/pages/register_page.dart';
import '../arch/presentation/case/view_case/pages/view_case_page.dart';
import '../arch/presentation/chat/pages/chat_page.dart';
import '../arch/presentation/home/pages/home_page.dart';
import 'guards/auth_guard.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
@singleton
class AppRouter extends _$AppRouter {
  AppRouter();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: LoginRoute.page, initial: true, guards: [getIt<AuthGuard>()]),
    AutoRoute(page: RegisterRoute.page),
    AutoRoute(page: HomeRoute.page),
    AutoRoute(page: ViewCaseRoute.page),
    AutoRoute(page: ChatRoute.page),
  ];
}
