import 'dart:async';

import 'package:app/services/auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class EmailVerificationScreen extends StatefulWidget {
  final Function refresh;

  const EmailVerificationScreen({
    super.key,
    required this.refresh,
  });

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final int retryDuration = 30;
  int retryCooldownSec = 0;

  @override
  initState() {
    super.initState();

    retryCooldownSec = retryCooldownSec;

    Timer.periodic(const Duration(seconds: 1), (Timer t) {
      AuthService().user!.reload().then((_) {
        if (AuthService().user!.emailVerified) {
          widget.refresh();
        }
      });

      if (retryCooldownSec == 0) return;

      setState(() {
        retryCooldownSec--;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: [
          const Spacer(),
          Icon(
            Icons.email_outlined,
            size: 200,
            color: Colors.blue[300],
          ),
          Text(AppLocalizations.of(context)!.pleaseVerifyYourEmailAddress),
          const Spacer(),
          ElevatedButton(
            style: retryCooldownSec != 0
                ? const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.grey),
                  )
                : null,
            onPressed: () {
              if (retryCooldownSec != 0) return;

              retryCooldownSec = retryDuration;
              AuthService().user!.sendEmailVerification();
            },
            child: Text(
                'Resend verification email ${retryCooldownSec != 0 ? retryCooldownSec.toString() : ''}'),
          ),
          TextButton(
            onPressed: () {
              AuthService().signOut();
            },
            child: Text(AppLocalizations.of(context)!.logOut),
          ),
          const Spacer(),
        ],
      )),
    );
  }
}
