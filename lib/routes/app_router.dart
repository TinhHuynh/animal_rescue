import 'package:animal_rescue/routes/guards/auth_guard.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../arch/domain/case/entities/case.dart';
import '../arch/domain/core/value_objects.dart';
import '../arch/presentation/auth/login/pages/login_page.dart';
import '../arch/presentation/auth/register/pages/register_page.dart';
import '../arch/presentation/case/view_case/pages/view_case_page.dart';
import '../arch/presentation/chat/pages/chat_page.dart';
import '../arch/presentation/home/pages/home_page.dart';


part 'app_router.gr.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(page: LoginPage, initial: true, guards: [AuthGuard]),
    AutoRoute(page: RegisterPage),
    AutoRoute(page: HomePage),
    AutoRoute(page: ViewCasePage),
    AutoRoute(page: ChatPage),
  ],
)
class AppRouter extends _$AppRouter{
  AppRouter({required super.authGuard});
}

