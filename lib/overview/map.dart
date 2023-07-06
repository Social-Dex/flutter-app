import 'package:app/overview/user_avatar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:app/shared/shared.dart';
import 'package:app/services/location.dart';
import 'package:app/services/user_data.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  final UserData userData;
  final Function onOwnMapAvatarPressed;

  const MapScreen({
    super.key,
    required this.userData,
    required this.onOwnMapAvatarPressed,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 25),
      child: FutureBuilder<Object>(
        future: Location().handleLocationPermission(context),
        builder: (context, snapshot) {
          if (snapshot.data == true) {
            return StreamBuilder<Object>(
                stream: widget.userData.position,
                builder: (context, snapshot) {
                  if (widget.userData.lastPosition != const LatLng(0, 0)) {
                    return FlutterMap(
                      options: MapOptions(
                        center: widget.userData.lastPosition,
                        zoom: 18,
                        maxZoom: 18,
                        minZoom: 15,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.social-dex.app',
                        ),
                        MarkerLayer(
                          rotate: true,
                          markers: [
                            Marker(
                              point: widget.userData.lastPosition,
                              width: 70,
                              height: 70,
                              builder: (context) => UserAvatar(
                                  statusColor: Colors.transparent,
                                  onPress: widget.onOwnMapAvatarPressed),
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                  return const Loader();
                });
          } else if (snapshot.data == false) {
            return Center(
              child: Column(
                children: [
                  const Spacer(),
                  Icon(
                    Icons.location_off_outlined,
                    size: 200,
                    color: Colors.red[300],
                  ),
                  Text(
                    AppLocalizations.of(context)!
                        .pleaseEnableLocationPermissions,
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                ],
              ),
            );
          }

          return const Loader();
        },
      ),
    );
  }
}
