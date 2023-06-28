import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text(AppLocalizations.of(context)!.locationServicesDisabled)));
        return false;
      }
      return await Geolocator.checkPermission().then((permission) async {
        if (permission == LocationPermission.deniedForever) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(AppLocalizations.of(context)!
                  .locationPermissionsPermDenied)));
          return false;
        }
        if (permission == LocationPermission.denied) {
          return await Geolocator.requestPermission().then((permission) async {
            if (permission == LocationPermission.denied) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(AppLocalizations.of(context)!
                      .locationPermissionsDenied)));
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
