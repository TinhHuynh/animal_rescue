import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomAnnotatedRegion extends StatelessWidget {
  final Widget child;
  final Color? statusBarColor;

  const CustomAnnotatedRegion(
      {super.key, required this.child, this.statusBarColor});

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
