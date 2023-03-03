import 'package:animal_rescue/extensions/any_x.dart';
import 'package:animal_rescue/extensions/context_x.dart';
import 'package:animal_rescue/extensions/dartz_x.dart';
import 'package:animal_rescue/routes/app_router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../di/get_it.dart';
import '../../../../application/case/view_case/view_case_cubit.dart';
import '../../../../domain/case/entities/case.dart';
import '../../../../domain/core/value_objects.dart';
import '../../../core/widgets/custom_annotated_region.dart';
import '../../../core/widgets/lifecycle_aware.dart';
import '../widgets/image_carousel.dart';


class ViewCasePage extends StatelessWidget {
  final UniqueId caseId;
  final Case? caze;

  const ViewCasePage({Key? key, required this.caseId, this.caze})
      : super(key: key);

  factory ViewCasePage.fromCase({Key? key, required Case caze}) => ViewCasePage(
        key: key,
        caseId: caze.id,
        caze: caze,
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ViewCaseCubit>(
      create: (context) => getIt<ViewCaseCubit>()..fetchCase(caseId, caze),
      child: CustomAnnotatedRegion(
        statusBarColor: Colors.white,
        child: Scaffold(
          appBar: AppBar(
            title: Text(context.s.case_detail),
            leading: backIcon(context),
            actions: [
              _chatIcon(context),
            ],
          ),
          body: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              child: LifecycleAware(
                child: BlocConsumer<ViewCaseCubit, ViewCaseState>(
                  buildWhen: (_, s) => s.event.isCaseLoaded,
                  listener: (context, state) {
                    if (state.event.isLoading) {
                      showLoading();
                    } else {
                      hideLoading();
                    }
                    state.event.maybeWhen(
                      orElse: () {},
                      loadCaseFailed: () => _showLoadCaseFailed(context),
                      resolveCaseFailed: () => _showResolveCaseFailed(context),
                      deleteCaseFailed: () => _showDeleteCaseFailed(context),
                      resolveCaseSuccessful: () =>
                          _showResolveCaseSuccessful(context),
                      deleteCaseSuccessful: () =>
                          _deleteCaseSuccessful(context),
                    );
                  },
                  builder: (context, state) {
                    return state.event.maybeWhen(
                        caseLoaded: () => state.loadCaseOption.foldDefaultLeft(
                              () => const SizedBox(),
                              (caze) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _imageCarousel(caze),
                                  _title(context, caze),
                                  _description(context, caze),
                                  _address(context, caze),
                                  if (state.isCreatedByUser) ...[
                                    _resolveButton(context, caze),
                                    _deleteButton(context, caze),
                                  ],
                                  SizedBox(
                                      height:
                                          context.mediaQuery.padding.bottom +
                                              32)
                                ],
                              ),
                            ),
                        orElse: () => const SizedBox());
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _chatIcon(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: GestureDetector(
        onTap: () {
          context.pushRoute(ChatRoute(caseId: caseId));
        },
        child: const Icon(
          Icons.messenger,
          color: Colors.black,
        ),
      ),
    );
  }

  _imageCarousel(Case caze) {
    return ImageCarousel(
        imageUrls:
            caze.photos.getOrCrash().map((e) => e.getOrCrash()).toList());
  }

  _title(BuildContext context, Case caze) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
      child: Text(caze.title.getOrCrash(),
          style: context.textTheme.headline4
              ?.copyWith(fontWeight: FontWeight.bold, color: Colors.black)),
    );
  }

  _description(BuildContext context, Case caze) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.s.description,
              style: context.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(
            height: 8,
          ),
          Text(caze.description.getOrCrash(),
              style: context.textTheme.bodyLarge),
        ],
      ),
    );
  }

  _address(BuildContext context, Case caze) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.s.address,
              style: context.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(
            height: 8,
          ),
          GestureDetector(
            onTap: () {
              _openMap(caze);
            },
            child: Text(
              caze.address.getOrCrash(),
              style: context.textTheme.bodyLarge?.copyWith(
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _openMap(Case caze) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=${caze.latitude.getOrCrash()},${caze.longitude.getOrCrash()}';
    final uri = Uri.parse(googleUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not open the map.';
    }
  }

  _resolveButton(BuildContext context, Case caze) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, left: 16, right: 16),
      child: ElevatedButton(
          onPressed: () {
            context.read<ViewCaseCubit>().resolveCase(caze);
          },
          child: Text(context.s.marked_as_resolved)),
    );
  }

  _deleteButton(BuildContext context, Case caze) {
    return Padding(
        padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
        child: ElevatedButton(
          onPressed: () {
            context.read<ViewCaseCubit>().deleteCase(caze);
          },
          style: context.theme.elevatedButtonTheme.style?.copyWith(
            backgroundColor: const MaterialStatePropertyAll(Colors.red),
          ),
          child: Text(context.s.delete),
        ));
  }

  _showLoadCaseFailed(BuildContext context) {
    showError(context, context.s.failed_to_load_case);
  }

  _showResolveCaseFailed(BuildContext context) {
    showError(context, context.s.failed_to_resolve_case);
  }

  _showDeleteCaseFailed(BuildContext context) {
    showError(context, context.s.failed_to_delete_case);
  }

  _showResolveCaseSuccessful(BuildContext context) {
    showToast(context.s.resolve_case_successful);
    context.popRoute();
  }

  _deleteCaseSuccessful(BuildContext context) {
    showToast(context.s.delete_case_successful);
    context.popRoute();
  }
}
