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

  static const int minPasswordLength = 8;

  @override
  State<CredentialsScreen> createState() => _CredentialsScreenState();
}

class _CredentialsScreenState extends State<CredentialsScreen> {
  bool _isPasswordVisible = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 60, left: 30, right: 30),
            child: Text(
              widget.helpText ?? '',
            ),
          ),
        ),
        widget.helpText != null && widget.helpText!.isNotEmpty
            ? const Spacer()
            : Container(),
        Padding(
          padding: const EdgeInsets.only(bottom: 30, left: 40, right: 40),
          child: TextFormField(
            controller: widget.cEmail,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.email,
            ),
            maxLines: 1,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (String? value) {
              value = value ?? '';
              // from https://firebase.google.com/docs/reference/security/database/regex
              const String emailRegex =
                  r'^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}$';

              if (!RegExp(emailRegex).hasMatch(value.toLowerCase())) {
                return AppLocalizations.of(context)!.invalid;
              }

              return null;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 30, left: 40, right: 40),
          child: TextFormField(
            controller: widget.cPassword,
            obscureText: !_isPasswordVisible,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.password,
              suffixIcon: Icon(
                  _isPasswordVisible ? Icons.visibility_off : Icons.visibility),
            ),
            maxLines: 1,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (String? value) {
              if (value == null || value.length < CredentialsScreen.minPasswordLength) {
                return AppLocalizations.of(context)!.tooShort;
              }

              return null;
            },
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
