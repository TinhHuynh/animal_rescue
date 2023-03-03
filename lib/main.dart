import 'package:animal_rescue/di/get_it.dart';
import 'package:animal_rescue/gen/colors.gen.dart';
import 'package:animal_rescue/utils/global_observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'arch/presentation/core/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupDi();
  Bloc.observer = GlobalObserver();
  runApp(App());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.light
    ..boxShadow = <BoxShadow>[]
    ..loadingStyle = EasyLoadingStyle.custom
    ..userInteractions = false
    ..backgroundColor = Colors.transparent
    ..indicatorColor = ColorName.brand
    ..textColor = Colors.white
    ..indicatorWidget = const CircularProgressIndicator()
    ..dismissOnTap = false;
}
