import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:app/services/user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  final UserData userData;

  const MapScreen({
    super.key,
    required this.userData,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 25),
      child: widget.userData.position == const LatLng(0, 0)
          ? Center(
              child: Column(
                children: [
                  const Spacer(),
                  Icon(
                    Icons.location_off_outlined,
                    size: 200,
                    color: Colors.red[300],
                  ),
                  Text(
                      AppLocalizations.of(context)!.pleaseEnableLocationPermissions),
                  const Spacer(),
                ],
              ),
            )
          : FlutterMap(
              options: MapOptions(
                center: widget.userData.position,
                zoom: 18,
                maxZoom: 18,
                minZoom: 15,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.social-dex.app',
                ),
                MarkerLayer(
                  rotate: true,
                  markers: [
                    Marker(
                      point: widget.userData.position,
                      width: 70,
                      height: 70,
                      builder: (context) =>
                          const Icon(Icons.circle_sharp, color: Colors.teal),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
