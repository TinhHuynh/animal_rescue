import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';

import '../arch/application/auth/login/login_cubit.dart';
import '../arch/application/auth/register/register_cubit.dart';
import '../arch/application/case/create_case/create_case_cubit.dart';
import '../arch/application/case/view_case/view_case_cubit.dart';
import '../arch/application/chat/chat_cubit.dart';
import '../arch/application/home/home_cubit.dart';
import '../arch/domain/auth/repositories/auth_repository.dart';
import '../arch/domain/case/repositories/case_repository.dart';
import '../arch/domain/chat/repositories/chat_repository.dart';
import '../arch/domain/location/repositories/location_repository.dart';
import '../arch/infrastructure/auth/repositories/auth_repository.dart';
import '../arch/infrastructure/case/repositories/case_repository.dart';
import '../arch/infrastructure/chat/repositories/chat_repository.dart';
import '../arch/infrastructure/core/firebase/auth_helper.dart';
import '../arch/infrastructure/core/firebase/firestore_helper.dart';
import '../arch/infrastructure/core/firebase/storage_helper.dart';
import '../arch/infrastructure/core/location/location_helper.dart';
import '../arch/infrastructure/location/repositories/location_repository.dart';

final getIt = GetIt.instance;

setupDi() {
  getIt.registerSingleton<AuthHelper>(AuthHelper(FirebaseAuth.instance));
  getIt.registerSingleton<FirestoreHelper>(
      FirestoreHelper(FirebaseFirestore.instance));
  getIt.registerSingleton<StorageHelper>(
      StorageHelper(FirebaseStorage.instance));
  getIt.registerSingleton<LocationHelper>(LocationHelper());

  getIt.registerFactory<AuthRepository>(() => (AuthRepositoryImpl(
      getIt<AuthHelper>(), getIt<FirestoreHelper>(), getIt<StorageHelper>())));
  getIt.registerFactory<LocationRepository>(
      () => (LocationRepositoryImpl(getIt<LocationHelper>())));
  getIt.registerFactory<CaseRepository>(() => (CaseRepositoryImpl(
      getIt<FirestoreHelper>(), getIt<StorageHelper>(), getIt<AuthHelper>())));
  getIt.registerFactory<ChatRepository>(() =>
      (ChatRepositoryImpl(getIt<FirestoreHelper>(), getIt<AuthHelper>())));

  getIt.registerFactory<LoginCubit>(() => LoginCubit(getIt<AuthRepository>()));
  getIt.registerFactory<RegisterCubit>(
      () => RegisterCubit(getIt<AuthRepository>()));
  getIt.registerFactory<HomeCubit>(() => HomeCubit(getIt<LocationRepository>(),
      getIt<CaseRepository>(), getIt<AuthRepository>()));
  getIt.registerFactory<CreateCaseCubit>(
      () => CreateCaseCubit(getIt<CaseRepository>()));
  getIt.registerFactory<ViewCaseCubit>(
      () => ViewCaseCubit(getIt<CaseRepository>(), getIt<AuthRepository>()));
  getIt.registerFactory<ChatCubit>(() => ChatCubit(getIt<ChatRepository>(),
      getIt<AuthRepository>(), getIt<CaseRepository>()));
}
