import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:app/services/user_data.dart';
import 'package:app/connections/connections.dart';
import 'package:app/map/map.dart';
import 'package:app/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key});

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  final UserData _userData = UserData();
  int _selectedIndex = 2;

  void _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetOptions = <Widget>[
      ProfileScreen(userData: _userData),
      MapScreen(userData: _userData),
      const ConnectionsScreen(),
    ];

    return Scaffold(
      body: LoaderOverlay(
        useDefaultLoading: false,
        overlayWidget:
            Center(child: Image.asset('assets/loading_animation.gif', width: (MediaQuery.of(context).size.width) * 0.6)),
        child: widgetOptions.elementAt(_selectedIndex),
      ),
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
    );
  }
}
