import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class LocationHandler {
  Location location = Location();

  LocationHandler() {
    location.changeSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5,
      interval: 10000,
    );
  }

  Stream<LatLng> getCurrentPosition(BuildContext context) {
    return location.onLocationChanged
        .map((pos) => LatLng(pos.latitude ?? 0, pos.longitude ?? 0));
  }

  Future<bool> handleLocationPermission(BuildContext context) async {
    return await location.serviceEnabled().then((isServiceEnabled) async {
      if (!isServiceEnabled) {
        await location.requestService().then((isEnabled) {
          if (!isEnabled) return false;
        });
      }
      return await location.hasPermission().then((permission) async {
        if (permission == PermissionStatus.denied) {
          return await location.requestPermission().then((permission) {
            if (permission == PermissionStatus.granted) {
              return true;
            }
            return false;
          });
        }
        return true;
      });
    });
  }
}
