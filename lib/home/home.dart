import 'package:app/register/email_verification.dart';
import 'package:flutter/material.dart';
import 'package:app/shared/shared.dart';
import 'package:app/services/auth.dart';
import 'package:app/overview/overview.dart';
import 'package:app/register/register.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
          if (snapshot.data!.emailVerified) {
            return const OverviewScreen();
          }
          return EmailVerificationScreen(
            refresh: () {
              setState(() {
                AuthService().user!.reload();
              });
            },
          );
        } else {
          return const RegisterScreen();
        }
      },
    );
  }
}
