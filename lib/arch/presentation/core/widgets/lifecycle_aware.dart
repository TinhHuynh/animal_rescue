import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';

import '../../../../extensions/any_x.dart';


class LifecycleAware extends StatelessWidget {
  const LifecycleAware(
      {Key? key,
      required this.child,
      this.onFocusGained,
      this.onFocusLost,
      this.onVisibilityGained,
      this.onVisibilityLost,
      this.onForegroundGained,
      this.onForegroundLost})
      : super(key: key);

  final Widget child;

  /// Called when the widget becomes visible or enters foreground while visible.
  final VoidCallback? onFocusGained;

  /// Called when the widget becomes invisible or enters background while visible.
  final VoidCallback? onFocusLost;

  /// Called when the widget becomes visible.
  final VoidCallback? onVisibilityGained;

  /// Called when the widget becomes invisible.
  final VoidCallback? onVisibilityLost;

  /// Called when the app entered the foreground while the widget is visible.
  final VoidCallback? onForegroundGained;

  /// Called when the app is sent to background while the widget was visible.
  final VoidCallback? onForegroundLost;

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
        onFocusGained: onFocusGained,
        onFocusLost: () {
          onFocusLost?.call();
          hideLoading();
        },
        onVisibilityGained: onVisibilityGained,
        onVisibilityLost: onVisibilityLost,
        onForegroundLost: onForegroundLost,
        onForegroundGained: onForegroundGained,
        child: child);
  }
}
