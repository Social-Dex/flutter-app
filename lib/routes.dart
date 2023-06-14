import 'package:app/connections/connections.dart';
import 'package:app/home/home.dart';
import 'package:app/login/login.dart';
import 'package:app/map/map.dart';
import 'package:app/profile/profile.dart';

var appRoutes = {
  '/': (context) => const HomeScreen(),
  '/login': (context) => const LoginScreen(),
  '/map': (context) => const MapScreen(),
  '/profile': (context) => const ProfileScreen(),
  '/connections': (context) => const ConnectionsScreen(),
};
