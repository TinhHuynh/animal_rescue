import 'package:animal_rescue/arch/domain/location/failures/location_failure.dart';
import 'package:animal_rescue/arch/presentation/home/widgets/drawer.dart';
import 'package:animal_rescue/di/get_it.dart';
import 'package:animal_rescue/extensions/context_x.dart';
import 'package:animal_rescue/routes/app_router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../extensions/any_x.dart';
import '../../../application/home/home_cubit.dart';
import '../../../domain/location/entities/location.dart';
import '../../case/create_case/pages/create_case_page.dart';
import '../../core/dialogs/alert_dialog.dart';
import '../../core/widgets/custom_annotated_region.dart';
import '../../core/widgets/lifecycle_aware.dart';
import '../widgets/map/custom_map.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return CustomAnnotatedRegion(
      child: LifecycleAware(
        child: BlocProvider(
          create: (context) => getIt<HomeCubit>()..init(),
          child: BlocListener<HomeCubit, HomeState>(
              listener: (context, state) => _onStateChange(context, state),
              child: Scaffold(
                key: _scaffoldKey,
                body: _googleMap(context),
                drawer: const HomeDrawer(),
              )),
        ),
      ),
    );
  }

  _onStateChange(BuildContext context, HomeState state) {
    toggleLoading(state.maybeWhen(orElse: () => false, loading: () => true));
    state.maybeWhen(
        orElse: () {},
        locationError: (e) => _onLocationError(e),
        locationUpdated: (l) => _showInstruction(),
        loggedOut: () => _onLoggedOut(context),
        logoutFailed: (e) => _onLogOutFailed(context));
  }

  _onLocationError(LocationFailure failure) {
    failure.when(
        serviceNotEnabled: () => showAlertDialog(
                context,
                context.s.error_disabled_location_service,
                context.s.error_disabled_location_service_msg, [
              AlertDialogAction(context.s.ok, () {
                Navigator.of(context).pop();
              })
            ]),
        permissionDenied: () => _showPermissionDeniedAlert(context),
        permissionDeniedForever: () => _showPermissionDeniedAlert(context),
        unableToQueryAtLocation: () =>
            _showUnableToQueryAtLocationToast(context));
  }

  Widget _googleMap(BuildContext context) {
    return CustomMap(
      onTap: (l) => _showCreateCaseSheet(context, l),
      onMarkerTap: (caze) {
        context.pushRoute(ViewCaseRoute(caseId: caze.id));
      },
    );
  }

  _showCreateCaseSheet(BuildContext context, Location location) {
    CreateCasePage.show(context, location);
  }

  _showPermissionDeniedAlert(BuildContext context) => showAlertDialog(
          context,
          context.s.error_permission_denied,
          context.s.error_permission_denied_msg, [
        AlertDialogAction(context.s.ok, () {
          Navigator.of(context).pop();
        })
      ]);

  void _showInstruction() {
    showToast(
      context.s.map_instructions,
    );
  }

  void _showUnableToQueryAtLocationToast(BuildContext context) {
    showToast(context.s.unable_to_query_location_of_cases,
        backgroundColor: Colors.red);
  }

  _onLoggedOut(BuildContext context) {
    _scaffoldKey.currentState?.closeDrawer();
    context.router.replace(const LoginRoute());
  }

  _onLogOutFailed(BuildContext context) {
    showError(context, context.s.failed_to_logout);
  }
}
