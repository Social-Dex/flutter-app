import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:app/services/auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: Text(AppLocalizations.of(context)!.logOut),
        onPressed: () {
          AuthService().signOut();
        },
      ),
    );
  }
}
