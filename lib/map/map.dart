import 'package:app/services/location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:async';

class MapScreen extends StatefulWidget {
  final LatLng initLocation;

  const MapScreen({
    super.key,
    required this.initLocation,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng _currentPosition = const LatLng(0.0, 0.0);

  Timer? timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(seconds: 3), (Timer t) async {
      var curPos = await Location().getCurrentPosition(context);
      setState(() {
        _currentPosition = curPos;
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 25),
      child: FlutterMap(
        options: MapOptions(
          center: widget.initLocation,
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
                point: _currentPosition,
                width: 70,
                height: 70,
                builder: (context) => const Icon(Icons.circle_sharp, color: Colors.teal),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
