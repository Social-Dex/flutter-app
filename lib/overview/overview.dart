import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:app/shared/shared.dart';
import 'package:app/services/user_data.dart';
import 'package:app/overview/connections.dart';
import 'package:app/overview/map.dart';
import 'package:app/overview/profile.dart';
import 'package:app/services/models.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key});

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  late final UserData _userData = UserData(context);
  int _selectedIndex = 1;

@override
  initState() {
    super.initState();
  }

  Future<UserProfile> _gatherUserData() async {
    return _userData.update();
  }

  void _onItemTapped(int index) async {
    if (index == _selectedIndex) return;
    
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onOwnMapAvatarPressed() {
    setState(() {
      _selectedIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Object>(
          future: _gatherUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loader();
            }

            List<Widget> widgetOptions = <Widget>[
              ProfileScreen(userData: _userData),
              MapScreen(userData: _userData, onOwnMapAvatarPressed: _onOwnMapAvatarPressed),
              const ConnectionsScreen(),
            ];

            return widgetOptions.elementAt(_selectedIndex);
          }),
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
