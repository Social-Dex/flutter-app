import 'package:flutter/material.dart';
import 'package:app/shared/shared.dart';
import 'package:app/services/auth.dart';
import 'package:app/overview/overview.dart';
import 'package:app/register/register.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: AuthService().userStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          }
          if (snapshot.hasError) {
            return const Scaffold(
              body: Padding(
                padding: EdgeInsets.all(10),
                child: ErrorScreen(),
              ),
            );
          } else if (snapshot.hasData) {
            return const OverviewScreen();
          } else {
            return const RegisterScreen();
          }
        });
  }
}
