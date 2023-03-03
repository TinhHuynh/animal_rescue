import 'dart:async';

import 'package:animal_rescue/extensions/dartz_x.dart';
import 'package:custom_marker/marker_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../application/home/home_cubit.dart';
import '../../../../domain/case/entities/case.dart';
import '../../../../domain/location/entities/location.dart';

class CustomMap extends StatefulWidget {
  final Function(Location location) onTap;
  final Function(Case caze) onMarkerTap;

  const CustomMap({Key? key, required this.onTap, required this.onMarkerTap})
      : super(key: key);

  @override
  State<CustomMap> createState() => _CustomMapState();
}

class _CustomMapState extends State<CustomMap> {
  static const String myLocationId = 'my-location';
  Set<Marker> _markers = <Marker>{};
  GoogleMapController? _mapController;
  StreamSubscription<List<Case>>? casesSub;

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listener: (context, state) {
        state.failureOrLocation.foldDefaultLeft(() {}, (r) {
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
    casesSub = context.read<HomeCubit>().observeNearbyCase(r).listen((event) {
      _handleLocation(event);
    });
  }

  Future<void> _handleLocation(List<Case> cases) async {
    _markers.removeWhere((element) => element.markerId.value != myLocationId);
    for (var element in cases) {
      final marker = _createCaseMarker(element);
      _markers.add(await marker);
    }
    setState(() {
      _markers = _markers;
    });
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
    casesSub?.cancel();
    super.dispose();
  }
}
