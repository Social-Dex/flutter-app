import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:app/services/location.dart';
import 'package:app/connections/connections.dart';
import 'package:app/map/map.dart';
import 'package:app/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:loader_overlay/loader_overlay.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key});

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  int _selectedIndex = 2;

  LatLng _initLocation = const LatLng(0.0, 0.0);

  void _onItemTapped(int index) async {
    context.loaderOverlay.show();

    LatLng curLocation = const LatLng(0.0, 0.0);
    if (index == 1) {
      curLocation = await Location().getCurrentPosition(context);
    }

    setState(() {
      _selectedIndex = index;
      if (index == 1) {
        _initLocation = curLocation;
      }
    });

    context.loaderOverlay.hide();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetOptions = <Widget>[
      const ProfileScreen(),
      MapScreen(initLocation: _initLocation),
      const ConnectionsScreen(),
    ];

    return LoaderOverlay(
      child: Scaffold(
        body: widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: const Icon(Icons.account_circle_outlined),
              label: AppLocalizations.of(context)!.profile,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.map_outlined),
              label: AppLocalizations.of(context)!.map,
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_outlined),
              label: 'Social-Dex',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
