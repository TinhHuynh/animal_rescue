import 'package:animal_rescue/extensions/any_x.dart';
import 'package:animal_rescue/extensions/context_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/home/home_cubit.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: EdgeInsets.only(
            top: paddingTopOr(context, 32),
            left: 24,
            right: 24,
            bottom: paddingBottomOr(context, 32)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_logoutText(context)],
        ),
      ),
    );
  }

  _logoutText(BuildContext context) {
    return GestureDetector(
      onTap: () => _logout(context),
      child: Text(context.s.logout,
          style: context.textTheme.titleMedium?.copyWith(color: Colors.red)),
    );
  }

  void _logout(BuildContext context) {
    context.read<HomeCubit>().logout();
  }
}
