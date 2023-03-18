import 'dart:io';

import 'package:animal_rescue/arch/infrastructure/auth/dtos/user_dto.dart';
import 'package:animal_rescue/utils/logger.dart';
import 'package:dartz/dartz.dart';

import '../../../domain/auth/entities/user.dart' as user;
import '../../../domain/auth/failures/auth_failure.dart';
import '../../../domain/auth/repositories/auth_repository.dart';
import '../../../domain/auth/value_objects/value_object.dart';
import '../../../domain/core/value_objects.dart';
import '../../core/firebase/auth_helper.dart' as auth;
import '../../core/firebase/firestore_helper.dart';
import '../../core/firebase/storage_helper.dart';

class AuthRepositoryImpl extends AuthRepository {
  final auth.AuthHelper _authHelper;
  final FirestoreHelper _firestoreHelper;
  final StorageHelper _storageHelper;

  AuthRepositoryImpl(
      this._authHelper, this._firestoreHelper, this._storageHelper);

  @override
  Future<Either<AuthFailure, Unit>> loginWithEmailAndPassword(
      EmailAddress emailAddress, Password password) async {
    try {
      await _authHelper.loginWithEmailAndPassword(
        emailAddress.getOrCrash(),
        password.getOrCrash(),
      );
      return right(unit);
    } on auth.UserNotFound {
      return left(const AuthFailure.invalidEmailAndPasswordCombination());
    } on auth.UnableToLogin {
      return left(const AuthFailure.serverError());
    }
  }

  @override
  Future<Either<AuthFailure, Unit>> registerWithEmailAndPassword(
    UserAvatar? userAvatar,
    Username username,
    EmailAddress emailAddress,
    StrictPassword password,
  ) async {
    try {
      final cred = await _authHelper.registerWithEmailAndPassword(
        emailAddress.getOrCrash(),
        password.getOrCrash(),
      );
      if (cred.user == null) {
        return left(const AuthFailure.serverError());
      }
      String? avatarUrl;
      if (userAvatar != null && userAvatar.isValid()) {
        avatarUrl = await _uploadAvatar(userAvatar, cred.user!.uid);
      }
      _createUserOnFireStore(user.User(
          uid: UniqueId.fromUniqueString(cred.user!.uid),
          email: emailAddress,
          username: username,
          avatarUrl: avatarUrl != null ? Url(avatarUrl) : null));
      return right(unit);
    } on auth.EmailAlreadyInUse {
      return left(const AuthFailure.emailAlreadyInUse());
    } on auth.UnableToRegister {
      return left(const AuthFailure.serverError());
    }
  }

  void _createUserOnFireStore(user.User user) {
    try {
      final dto = UserDto.fromDomain(user);
      _firestoreHelper.createUser(dto);
    } on UnableToCreateUser {
      logger.e('Unable to create user');
    }
  }

  Future<String?> _uploadAvatar(UserAvatar userAvatar, String uid) async {
    try {
      File file = File(userAvatar.getOrCrash());
      await _storageHelper.uploadAvatar(file, uid);
      return await _storageHelper.getAvatarUrl(uid);
    } on UnableToUploadFileException {
      logger.e('Unable to upload image for uid $uid');
    } on UnableToGetImageUrlException {
      logger.e('Unable to get image URL for uid $uid');
    } catch (e) {
      logger.e(e);
    }
    return null;
  }

  @override
  bool isUserLoggedIn() {
    return _authHelper.isSignedIn();
  }

  @override
  String? getUserId() {
    return _authHelper.getUserId();
  }

  @override
  Future<Either<AuthFailure, Unit>> logout() async {
    try {
      await _authHelper.logout();
      return right(unit);
    } catch (e) {
      return left(const AuthFailure.unableToLogOut());
    }
  }
}
