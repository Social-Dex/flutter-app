import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:url_launcher/url_launcher.dart';

class CodexScreen extends StatefulWidget {
  final Function(bool value) onTACChanged;
  final bool initAccept;

  const CodexScreen({
    super.key,
    required this.onTACChanged,
    this.initAccept = false,
  });

  @override
  State<CodexScreen> createState() => _CodexScreenState();
}

class _CodexScreenState extends State<CodexScreen> {
  bool acceptedTAC = false;

  @override
  Widget build(BuildContext context) {
    acceptedTAC = widget.initAccept;

    return Center(
      child: Column(
        children: [
          const Spacer(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                '✌️ ${AppLocalizations.of(context)!.codexRespect}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                '🕵️ ${AppLocalizations.of(context)!.codexPrivacy}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                '😇 ${AppLocalizations.of(context)!.codexAuthenticity}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          const Spacer(),
          Row(
            children: [
              const Spacer(),
              Checkbox(
                value: acceptedTAC,
                onChanged: (bool? isChecked) {
                  setState(() {
                    acceptedTAC = isChecked ?? false;
                  });
                  widget.onTACChanged(isChecked ?? false);
                },
              ),
              Text(
                AppLocalizations.of(context)!.iAcceptThe,
                textAlign: TextAlign.center,
              ),
              TextButton(
                child: Row(
                  children: [
                    Text(AppLocalizations.of(context)!.termsAndConditions),
                    const Icon(Icons.open_in_new_rounded, color: Colors.teal),
                  ],
                ),
                onPressed: () async {
                  context.loaderOverlay.show();
                  var url =
                      Uri.parse('https://social-dex.com/terms-and-conditions/');
                  await launchUrl(url, mode: LaunchMode.inAppWebView)
                      .then((value) => context.loaderOverlay.hide());
                },
              ),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}
