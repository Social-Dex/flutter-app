import 'package:app/overview/overview.dart';
import 'package:app/register/register.dart';
import 'package:app/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:app/services/auth.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: AuthService().userStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error'),
            );
          } else if (snapshot.hasData) {
            return const OverviewScreen();
          } else {
            return const RegisterScreen();
          }
        });
  }
}
