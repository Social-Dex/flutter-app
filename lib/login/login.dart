import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:app/login/credentials.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final cEmail = TextEditingController();
  final cPassword = TextEditingController();

  String email = '';
  String password = '';

  bool isValidEmail = false;
  bool isValidPassword = false;
  bool areValidCredentials = false;
  String loginError = '';

  @override
  initState() {
    super.initState();

    cEmail.addListener(() {
      email = cEmail.text;

      setState(() {
        isValidEmail =
            CredentialsScreen.getValidationErrorEmail(context, email) == null;
        areValidCredentials = isValidEmail && isValidPassword;

        loginError = '';
      });
    });
    cPassword.addListener(() {
      password = cPassword.text;

      setState(() {
        isValidPassword =
            CredentialsScreen.getValidationErrorPassword(context, password) ==
                null;
        areValidCredentials = isValidEmail && isValidPassword;

        loginError = '';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.logIn),
        ),
        body: Column(
          children: [
            Expanded(
              child: CredentialsScreen(cEmail: cEmail, cPassword: cPassword),
            ),
            loginError != ''
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      loginError,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              const Spacer(),
              ElevatedButton(
                style: areValidCredentials
                    ? null
                    : const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.grey),
                        overlayColor: MaterialStatePropertyAll(Colors.grey),
                      ),
                child: Text(AppLocalizations.of(context)!.logIn),
                onPressed: () async {
                  if (!areValidCredentials) return;
                  
                  context.loaderOverlay.show();

                  try {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: email.toLowerCase(),
                      password: password,
                    );
                  } on FirebaseAuthException catch (e) {
                    setState(() {
                      switch (e.code) {
                        case 'network-request-failed':
                          loginError = AppLocalizations.of(context)!
                              .exceptionNetworkRequestFailed;
                          break;
                        case 'invalid-email':
                          loginError = AppLocalizations.of(context)!
                              .exceptionInvalidEmail;
                          break;
                        case 'user-disabled':
                          loginError = AppLocalizations.of(context)!
                              .exceptionUserDisabled;
                          break;
                        case 'user-not-found':
                          loginError = AppLocalizations.of(context)!
                              .exceptionUserNotFound;
                          break;
                        case 'wrong-password':
                          loginError = AppLocalizations.of(context)!
                              .exceptionWrongPassword;
                          break;
                        default:
                          loginError = AppLocalizations.of(context)!
                              .unexpectedErrorOccured;
                      }
                    });

                    context.loaderOverlay.hide();
                    return;
                  }

                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                  // ignore: use_build_context_synchronously
                  context.loaderOverlay.hide();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
