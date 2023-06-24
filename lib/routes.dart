import 'package:app/home/home.dart';
import 'package:app/login/login.dart';
import 'package:app/overview/overview.dart';

var appRoutes = {
  '/': (context) => const HomeScreen(),
  '/login': (context) => const LoginScreen(),
  '/overview': (context) => const OverviewScreen(),
};
