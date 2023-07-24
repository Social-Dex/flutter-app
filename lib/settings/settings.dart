import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:app/services/auth.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:app/shared/shared.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayWidget: const Loader(),
      child: Scaffold(
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
                    context.loaderOverlay.show();

                    AuthService().signOut().then((_) {
                      Navigator.of(context).pop();
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
