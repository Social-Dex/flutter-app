import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:url_launcher/url_launcher.dart';

class CodexScreen extends StatefulWidget {
  final Function(bool value) onTACChanged;
  final Function(bool value) onDPAChanged;
  final bool initAcceptTAC;
  final bool initAcceptDPA;

  const CodexScreen({
    super.key,
    this.initAcceptTAC = false,
    this.initAcceptDPA = false,
    required this.onTACChanged,
    required this.onDPAChanged,
  });

  @override
  State<CodexScreen> createState() => _CodexScreenState();
}

class _CodexScreenState extends State<CodexScreen> {
  bool acceptedTAC = false;
  bool acceptedDPA = false;

  @override
  Widget build(BuildContext context) {
    acceptedTAC = widget.initAcceptTAC;
    acceptedDPA = widget.initAcceptDPA;

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
                style: const TextStyle(fontSize: 14),
              ),
              TextButton(
                child: Text(
                  AppLocalizations.of(context)!.termsAndConditions,
                  style: const TextStyle(fontSize: 14),
                ),
                onPressed: () async {
                  context.loaderOverlay.show();
                  var url =
                      Uri.parse('https://social-dex.com/terms-and-conditions/');
                  await launchUrl(url, mode: LaunchMode.inAppWebView)
                      .then((_) => context.loaderOverlay.hide());
                },
              ),
              const Spacer(),
            ],
          ),
          Row(
            children: [
              const Spacer(),
              Checkbox(
                value: acceptedDPA,
                onChanged: (bool? isChecked) {
                  setState(() {
                    acceptedDPA = isChecked ?? false;
                  });
                  widget.onDPAChanged(isChecked ?? false);
                },
              ),
              Text(
                AppLocalizations.of(context)!.iAcceptThe,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
              TextButton(
                child: Text(
                  AppLocalizations.of(context)!.dataProtectionAgreement,
                  style: const TextStyle(fontSize: 14),
                ),
                onPressed: () async {
                  context.loaderOverlay.show();
                  var url =
                      Uri.parse('https://social-dex.com/data-protection/');
                  await launchUrl(url, mode: LaunchMode.inAppWebView)
                      .then((_) => context.loaderOverlay.hide());
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
