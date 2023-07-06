import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:fluttermoji/fluttermoji.dart';

class AvatarCustomizerScreen extends StatelessWidget {
  final Function onBack;

  const AvatarCustomizerScreen(
    this.onBack, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              onBack();
              Navigator.of(context).pop();
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
                  secondaryBgColor: Colors.black12,
                  selectedIconColor: Colors.teal,
                ),
                autosave: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
