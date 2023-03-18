// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

part of 'app_router.dart';

class _$AppRouter extends RootStackRouter {
  _$AppRouter({
    GlobalKey<NavigatorState>? navigatorKey,
    required this.authGuard,
  }) : super(navigatorKey);

  final AuthGuard authGuard;

  @override
  final Map<String, PageFactory> pagesMap = {
    LoginRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const LoginPage(),
      );
    },
    RegisterRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const RegisterPage(),
      );
    },
    HomeRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const HomePage(),
      );
    },
    ViewCaseRoute.name: (routeData) {
      final args = routeData.argsAs<ViewCaseRouteArgs>();
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: ViewCasePage(
          key: args.key,
          caseId: args.caseId,
        ),
      );
    },
    ChatRoute.name: (routeData) {
      final args = routeData.argsAs<ChatRouteArgs>();
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: ChatPage(
          key: args.key,
          caseId: args.caseId,
        ),
      );
    },
  };

  @override
  List<RouteConfig> get routes => [
        RouteConfig(
          LoginRoute.name,
          path: '/',
          guards: [authGuard],
        ),
        RouteConfig(
          RegisterRoute.name,
          path: '/register-page',
        ),
        RouteConfig(
          HomeRoute.name,
          path: '/home-page',
        ),
        RouteConfig(
          ViewCaseRoute.name,
          path: '/view-case-page',
        ),
        RouteConfig(
          ChatRoute.name,
          path: '/chat-page',
        ),
      ];
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute()
      : super(
          LoginRoute.name,
          path: '/',
        );

  static const String name = 'LoginRoute';
}

/// generated route for
/// [RegisterPage]
class RegisterRoute extends PageRouteInfo<void> {
  const RegisterRoute()
      : super(
          RegisterRoute.name,
          path: '/register-page',
        );

  static const String name = 'RegisterRoute';
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute()
      : super(
          HomeRoute.name,
          path: '/home-page',
        );

  static const String name = 'HomeRoute';
}

/// generated route for
/// [ViewCasePage]
class ViewCaseRoute extends PageRouteInfo<ViewCaseRouteArgs> {
  ViewCaseRoute({
    Key? key,
    required UniqueId caseId,
  }) : super(
          ViewCaseRoute.name,
          path: '/view-case-page',
          args: ViewCaseRouteArgs(
            key: key,
            caseId: caseId,
          ),
        );

  static const String name = 'ViewCaseRoute';
}

class ViewCaseRouteArgs {
  const ViewCaseRouteArgs({
    this.key,
    required this.caseId,
  });

  final Key? key;

  final UniqueId caseId;

  @override
  String toString() {
    return 'ViewCaseRouteArgs{key: $key, caseId: $caseId}';
  }
}

/// generated route for
/// [ChatPage]
class ChatRoute extends PageRouteInfo<ChatRouteArgs> {
  ChatRoute({
    Key? key,
    required UniqueId caseId,
  }) : super(
          ChatRoute.name,
          path: '/chat-page',
          args: ChatRouteArgs(
            key: key,
            caseId: caseId,
          ),
        );

  static const String name = 'ChatRoute';
}

class ChatRouteArgs {
  const ChatRouteArgs({
    this.key,
    required this.caseId,
  });

  final Key? key;

  final UniqueId caseId;

  @override
  String toString() {
    return 'ChatRouteArgs{key: $key, caseId: $caseId}';
  }
}
