import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class CredentialsScreen extends StatefulWidget {
  final TextEditingController cEmail;
  final TextEditingController cPassword;
  final String? helpText;

  const CredentialsScreen({
    super.key,
    required this.cEmail,
    required this.cPassword,
    this.helpText,
  });

  @override
  State<CredentialsScreen> createState() =>
      // ignore: no_logic_in_create_state
      _CredentialsScreenState(cEmail, cPassword, helpText);
}

class _CredentialsScreenState extends State<CredentialsScreen> {
  _CredentialsScreenState(
    this.cEmail,
    this.cPassword,
    this.helpText,
  );

  final TextEditingController cEmail;
  final TextEditingController cPassword;
  final String? helpText;

  bool _isPasswordVisible = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 60, left: 30, right: 30),
            child: Text(
              helpText ?? '',
            ),
          ),
        ),
        helpText != null && helpText!.isNotEmpty ? const Spacer() : Container(),
        Padding(
          padding: const EdgeInsets.only(bottom: 30, left: 40, right: 40),
          child: TextFormField(
            controller: cEmail,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.email,
            ),
            maxLines: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 30, left: 40, right: 40),
          child: TextFormField(
            controller: cPassword,
            obscureText: !_isPasswordVisible,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.password,
              suffixIcon: Icon(
                  _isPasswordVisible ? Icons.visibility_off : Icons.visibility),
            ),
            maxLines: 1,
            onTap: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
