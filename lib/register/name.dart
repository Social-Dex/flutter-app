import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:url_launcher/url_launcher.dart';

class NameScreen extends StatefulWidget {
  final TextEditingController cName;
  final bool initAccept;
  final Function(bool value) onTACChanged;

  const NameScreen({
    super.key,
    required this.cName,
    required this.initAccept,
    required this.onTACChanged,
  });

  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  bool acceptedTAC = false;

  @override
  Widget build(BuildContext context) {
    acceptedTAC = widget.initAccept;

    return Column(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 60, left: 30, right: 30),
            child: Text(
              AppLocalizations.of(context)!.registerHelpTextName,
            ),
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(bottom: 10, left: 40, right: 40),
          child: TextFormField(
            keyboardType: TextInputType.name,
            controller: widget.cName,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.name,
            ),
            maxLength: 20,
            maxLines: 1,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (String? value) {
              return validateName(context, value ?? '');
            },
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/login');
          },
          child: Text(
            AppLocalizations.of(context)!.logInInstead,
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
              child: Text(AppLocalizations.of(context)!.termsAndConditions),
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
    );
  }
}

String? validateName(BuildContext context, String value) {
  if (value.isEmpty) {
    return AppLocalizations.of(context)!.nameCantBeEmpty;
  }
  return null;
}