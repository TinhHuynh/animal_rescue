import 'dart:async';

import 'package:animal_rescue/arch/presentation/core/widgets/lifecycle_aware.dart';
import 'package:custom_marker/marker_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../application/home/home_cubit.dart';
import '../../../../domain/case/entities/case.dart';
import '../../../../domain/location/entities/location.dart';

class CustomMap extends StatefulWidget {
  final OnMapTap onTap;
  final OnMarkerTap onMarkerTap;
  final OnMarkerLoading? onMarkerLoading;
  final OnMarkerLoaded? onMarkerLoaded;

  const CustomMap(
      {super.key,
      required this.onTap,
      required this.onMarkerTap,
      this.onMarkerLoading,
      this.onMarkerLoaded});

  @override
  State<CustomMap> createState() => _CustomMapState();
}

class _CustomMapState extends State<CustomMap> {
  static const String myLocationId = 'my-location';
  Set<Marker> _markers = <Marker>{};
  GoogleMapController? _mapController;
  StreamSubscription<List<Case>>? _casesSub;

  @override
  Widget build(BuildContext context) {
    return LifecycleAware(
      onVisibilityLost: (){
        _casesSub?.pause();
      },
      onVisibilityGained: (){
        _casesSub?.resume();
      },
      child: BlocListener<HomeCubit, HomeState>(
        listener: (context, state) {
          state.maybeWhen(
              orElse: () {},
              locationUpdated: (r) {
                _onMyLocationUpdated(r);
                _setUpCaseLocationStream(context, r);
              });
        },
        child: GoogleMap(
            myLocationButtonEnabled: false,
            initialCameraPosition: const CameraPosition(
              target: LatLng(0.0, 0.0),
            ),
            mapType: MapType.normal,
            zoomControlsEnabled: false,
            compassEnabled: false,
            myLocationEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            onTap: (p) => widget.onTap.call(
                Location.double(latitude: p.latitude, longitude: p.longitude)),
            markers: _markers),
      ),
    );
  }

  Future<void> _onMyLocationUpdated(Location location) async {
    final latLng =
        LatLng(location.latitude.getOrCrash(), location.longitude.getOrCrash());
    final myMaker = Marker(
        icon: await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(30, 30)),
            Assets.images.markerMyLocation.path),
        markerId: const MarkerId(myLocationId),
        position: latLng);
    setState(() {
      _markers.removeWhere((element) => element.markerId.value == myLocationId);
      _markers.add(myMaker);
    });
    _goToThePosition(CameraPosition(zoom: 16, target: latLng));
  }

  Future<void> _goToThePosition(CameraPosition cameraPosition) async {
    _mapController
        ?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  void _setUpCaseLocationStream(BuildContext context, Location r) {
    _markers.removeWhere((element) => element.markerId.value != myLocationId);
    _casesSub = context.read<HomeCubit>().observeNearbyCase(r).listen((event) {
      _handleLocation(event);
    });
  }

  Future<void> _handleLocation(List<Case> cases) async {
    widget.onMarkerLoading?.call();
    _markers.removeWhere((element) => element.markerId.value != myLocationId);
    for (var element in cases) {
      final marker = await _createCaseMarker(element);
      _markers.add(marker);
    }
    setState(() {
      _markers = _markers;
    });
    widget.onMarkerLoaded?.call(_markers
        .where((element) => element.markerId.value != myLocationId)
        .toList());
  }

  Future<Marker> _createCaseMarker(Case caze) async {
    return Marker(
        icon: await MarkerIcon.downloadResizePictureCircle(
            caze.photos.getOrCrash().elementAt(0).getOrCrash(),
            size: 150,
            addBorder: true,
            borderColor: Colors.white,
            borderSize: 15),
        markerId: MarkerId(caze.id.getOrCrash()),
        position:
            LatLng(caze.latitude.getOrCrash(), caze.longitude.getOrCrash()),
        onTap: () => widget.onMarkerTap.call(caze));
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _casesSub?.cancel();
    super.dispose();
  }
}

typedef OnMapTap = Function(Location location);
typedef OnMarkerTap = Function(Case caze);
typedef OnMarkerLoading = Function();
typedef OnMarkerLoaded = Function(List<Marker> markers);
