import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';


mixin Cancellable<T> on BlocBase<T> {
  List<StreamSubscription> subscriptions = [];

  @override
  Future<void> close() {
    for (var element in subscriptions) {
      element.cancel();
    }
    return super.close();
  }

  add(StreamSubscription subscription){
    subscriptions.add(subscription);
  }
}