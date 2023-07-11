import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:app/shared/shared.dart';
import 'package:app/services/firestore.dart';
import 'package:app/services/models.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:loader_overlay/loader_overlay.dart';

class AvatarCustomizerScreen extends StatelessWidget {
  final UserProfile profile;

  const AvatarCustomizerScreen(this.profile, {super.key});

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayWidget: const Loader(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () async {
                context.loaderOverlay.show();

                profile.avatarSVG =
                    await FluttermojiFunctions().encodeMySVGtoString();
                
                await FirestoreService()
                    .updateUserProfile(profile)
                    .then((value) {
                  Navigator.of(context).pop();
                  context.loaderOverlay.hide();
                });
              }),
          title: Text(AppLocalizations.of(context)!.avatarCustomization),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: FluttermojiCircleAvatar(
                    radius: 100,
                    backgroundColor: Colors.transparent,
                  ),
                ),
                FluttermojiCustomizer(
                  theme: FluttermojiThemeData(
                    labelTextStyle: Theme.of(context).textTheme.titleLarge,
                    primaryBgColor: Colors.transparent,
                    secondaryBgColor: Colors.white24,
                    selectedIconColor: Colors.teal,
                  ),
                  autosave: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
