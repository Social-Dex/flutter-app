import 'package:app/register/help_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class NameScreen extends StatefulWidget {
  final TextEditingController cName;

  const NameScreen({
    super.key,
    required this.cName,
  });

  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HelpText(AppLocalizations.of(context)!.registerHelpTextName),
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