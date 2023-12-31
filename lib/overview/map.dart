import 'dart:async';

import 'package:app/overview/user_view.dart';
import 'package:app/services/auth.dart';
import 'package:app/services/firestore.dart';
import 'package:app/services/models.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:app/shared/shared.dart';
import 'package:app/services/location.dart';
import 'package:app/services/user_data.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:app/overview/user_avatar.dart';

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
  final String styleUrl =
      'https://tiles.stadiamaps.com/tiles/alidade_smooth_dark/{z}/{x}/{y}{r}.png';
  final String apiKey = '6ee70282-81f7-499d-be1d-5b0e70fbbea1';

  late Timer timer;

  @override
  initState() {
    super.initState();

    timer = Timer.periodic(const Duration(seconds: 10), (Timer t) {
      if (AuthService().user == null) {
        timer.cancel();
      } else {
        widget.userData.updateUserPositions().then((value) {
          setState(() {});
        });
      }
    });
  }

  @override
  dispose() {
    super.dispose();

    timer.cancel();
  }

  List<Marker> getUsers() {
    List<Marker> users = [];

    widget.userData.userPositions.forEach((key, value) {
      users.add(Marker(
        point: value.position,
        width: 90,
        height: 90,
        builder: (context) => UserAvatar(
            heroTag: 'avatar-$key',
            statusColor: UserStatus.getProp(value.status).color,
            svg: value.avatarSVG,
            onPress: () {
              FirestoreService()
                  .getUserProfile(userId: key)
                  .then((userProfile) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => UserView(
                      userId: key,
                      avatarSVG: value.avatarSVG,
                      statusColor: UserStatus.getProp(
                        value.status,
                      ).color,
                      userProfile: userProfile,
                      userData: widget.userData,
                    ),
                  ),
                );
              });
            }),
      ));
    });

    users.add(
      Marker(
        point: widget.userData.lastPosition,
        width: 90,
        height: 90,
        builder: (context) => UserAvatar(
            statusColor: Colors.transparent,
            onPress: widget.onOwnMapAvatarPressed),
      ),
    );

    return users;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 30),
      child: FutureBuilder<Object>(
        future: LocationHandler().handleLocationPermission(context),
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
                        keepAlive: true,
                      ),
                      nonRotatedChildren: [
                        RichAttributionWidget(
                          attributions: [
                            TextSourceAttribution(
                              'Stadia Maps © OpenMapTiles © OpenStreetMap contributors',
                              onTap: () async {
                                launchUrl(
                                  Uri.parse(
                                      'https://stadiamaps.com/attribution'),
                                  mode: LaunchMode.inAppWebView,
                                ).then((success) {
                                  if (!success) {
                                    Fluttertoast.showToast(
                                        msg: AppLocalizations.of(context)!
                                            .unexpectedErrorOccured,
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.SNACKBAR,
                                        timeInSecForIosWeb: 3,
                                        backgroundColor: Colors.red[300],
                                        textColor:
                                            Theme.of(context).canvasColor,
                                        fontSize: 18);
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                      children: [
                        TileLayer(
                          urlTemplate: '$styleUrl?api_key={api_key}',
                          userAgentPackageName: 'com.social-dex.app',
                          maxZoom: 18,
                          maxNativeZoom: 18,
                          additionalOptions: {'api_key': apiKey},
                        ),
                        MarkerLayer(
                          rotate: true,
                          markers: getUsers(),
                        ),
                      ],
                    );
                  }
                  return const Loader();
                });
          } else if (snapshot.data == false ||
              snapshot.data == const LatLng(0, 0) ||
              snapshot.error != null) {
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
