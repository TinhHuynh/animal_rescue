import 'package:auto_route/auto_route.dart';

import '../../arch/domain/auth/repositories/auth_repository.dart';
import '../app_router.dart';

class AuthGuard extends AutoRouteGuard {
  final AuthRepository _repository;

  AuthGuard(this._repository);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final authenticated = _repository.isUserLoggedIn();
    if (!authenticated) {
      resolver.next(true);
    } else {
      router.push(const HomeRoute());
    }
  }
}
