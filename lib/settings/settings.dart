import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:app/services/auth.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.settings)),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.7,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.2),
              child: ElevatedButton(
                child: Text(AppLocalizations.of(context)!.logOut),
                onPressed: () {
                  AuthService().signOut().then((value) {
                    Navigator.of(context).pop();
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
