import 'package:dartz/dartz.dart';

import '../failures/auth_failure.dart';
import '../value_objects/value_object.dart';

abstract class AuthRepository {
  Future<Either<AuthFailure, Unit>> loginWithEmailAndPassword(
    EmailAddress emailAddress,
    Password password,
  );

  Future<Either<AuthFailure, Unit>> registerWithEmailAndPassword(
    UserAvatar userAvatar,
    Username username,
    EmailAddress emailAddress,
    StrictPassword password,
  );

  bool isUserLoggedIn();

  String? getUserId();
}
