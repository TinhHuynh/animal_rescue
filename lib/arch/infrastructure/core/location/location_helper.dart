import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

import '../../location/dtos/location_dto.dart';

@lazySingleton
class LocationHelper {
  static String path = "Sites";

  Future<LocationDto> getCurrentPosition() async {
    try {
      await _checkPermission();
      final p = await Geolocator.getCurrentPosition();
      return LocationDto(lat: p.latitude, long: p.longitude);
    } catch (e) {
      rethrow;
    }
  }

  _checkPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw ServiceNotEnabled();
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw PermissionDenied();
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw PermissionDeniedForever();
    }
  }
}

class ServiceNotEnabled implements Exception {}

class PermissionDenied implements Exception {}

class PermissionDeniedForever implements Exception {}