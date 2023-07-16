import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class LocationHandler {
  Stream<LatLng> getCurrentPosition(BuildContext context) {
    Location location = Location();
    location.enableBackgroundMode(enable: true);

    location.changeNotificationOptions(
      title: 'Social-Dex',
      description: 'Social-Dex',
      iconName: 'logo_trns_bg',
      color: Color(int.parse('#07224f'.substring(1, 7), radix: 16) + 0xFF000000),
      onTapBringToFront: true,
    );

    return location.onLocationChanged
        .map((pos) => LatLng(pos.latitude ?? 0, pos.longitude ?? 0));
  }

  Future<bool> handleLocationPermission(BuildContext context) async {
    Location location = Location();

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
