import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class Location {
  Stream<LatLng> getCurrentPosition() {
    return Geolocator.getPositionStream(
            locationSettings: const LocationSettings(
                accuracy: LocationAccuracy.bestForNavigation))
        .map((pos) => LatLng(pos.latitude, pos.longitude));
  }

  Future<bool> handleLocationPermission(BuildContext context) async {
    return await Geolocator.isLocationServiceEnabled()
        .then((isServiceEnabled) async {
      if (!isServiceEnabled) {
        return false;
      }
      return await Geolocator.checkPermission().then((permission) async {
        if (permission == LocationPermission.deniedForever) {
          return false;
        }
        if (permission == LocationPermission.denied) {
          return await Geolocator.requestPermission().then((permission) async {
            if (permission == LocationPermission.denied) {
              return false;
            }
            return true;
          });
        }
        return true;
      });
    });
  }
}
