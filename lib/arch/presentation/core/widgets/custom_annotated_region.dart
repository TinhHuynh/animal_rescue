import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomAnnotatedRegion extends StatelessWidget {
  final Widget child;
  final Color? statusBarColor;

  const CustomAnnotatedRegion(
      {Key? key, required this.child, this.statusBarColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: statusBarColor ?? Colors.transparent,
      ),
      child: child,
    );
  }
}
