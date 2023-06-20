import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app/login/credentials.dart';
import 'package:app/register/bday_picker.dart';
import 'package:app/services/models.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final userData = UserData();

  int _curScreen = 1;

  List<Widget> _buildScreenIndicator(BuildContext context) {
    List<Widget> indicator = [];

    for (int i = 0; i < Screens.total; i++) {
      indicator.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.5),
          child: Container(
            height: 10,
            width: (MediaQuery.of(context).size.width / Screens.total) - 5,
            decoration: _curScreen >= i + 1
                ? BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(8),
                  )
                : BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                      width: 1,
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
          ),
        ),
      );
    }

    return indicator;
  }

  final cName = TextEditingController();
  bool isValidName = true; // TODO false setzen
  bool acceptedTAC = true; // TODO false setzen
  void _onTACChanged(bool value) {
    setState(() {
      acceptedTAC = value;
    });
  }

  final TextEditingController cYear = TextEditingController();
  final TextEditingController cMonth = TextEditingController();
  final TextEditingController cDay = TextEditingController();
  final SimpleDate birthDate = SimpleDate();
  bool isValidDate = true; // TODO false setzen

  final cEmail = TextEditingController();
  final cPassword = TextEditingController();
  String email = '';
  String password = '';
  bool isValidEmail = false;
  bool isValidPassword = false;
  bool areValidCredentials = false;
  String credentialsError = '';

  @override
  initState() {
    super.initState();

    cName.addListener(() {
      userData.name = cName.text;

      setState(() {
        isValidName = _validateName(context, userData.name) == null;
      });
    });
    cYear.addListener(() {
      birthDate.year = _getSanitizedDateInput(4, cYear.text);
      setState(() {
        isValidDate = BDayPicker.getValidationError(context, birthDate) == '';
      });
    });
    cMonth.addListener(() {
      birthDate.month = _getSanitizedDateInput(2, cMonth.text);
      setState(() {
        isValidDate = BDayPicker.getValidationError(context, birthDate) == '';
      });
    });
    cDay.addListener(() {
      birthDate.day = _getSanitizedDateInput(2, cDay.text);
      setState(() {
        isValidDate = BDayPicker.getValidationError(context, birthDate) == '';
      });
    });
    cEmail.addListener(() {
      email = cEmail.text;

      setState(() {
        isValidEmail =
            CredentialsScreen.getValidationErrorEmail(context, email) == null;
        areValidCredentials = isValidEmail && isValidPassword;

        credentialsError = '';
      });
    });
    cPassword.addListener(() {
      password = cPassword.text;

      setState(() {
        isValidPassword =
            CredentialsScreen.getValidationErrorPassword(context, password) ==
                null;
        areValidCredentials = isValidEmail && isValidPassword;

        credentialsError = '';
      });
    });
  }

  int _getSanitizedDateInput(int length, String? value) {
    if (value == null || value.isEmpty) {
      return 1;
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 1;
    }

    if (value.toString().length > length) {
      return int.parse(value.substring(0, length));
    }

    return int.parse(value);
  }

  @override
  void dispose() {
    super.dispose();

    cName.dispose();
    cYear.dispose();
    cMonth.dispose();
    cDay.dispose();
    cEmail.dispose();
    cPassword.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> inputSreens = <Widget>[
      NameScreen(
          cName: cName, initAccept: acceptedTAC, onTACChanged: _onTACChanged),
      BirthDateScreen(cYear: cYear, cMonth: cMonth, cDay: cDay),
      const CodexScreen(),
      Column(children: [
        Expanded(
          child: CredentialsScreen(
            cEmail: cEmail,
            cPassword: cPassword,
            helpText: AppLocalizations.of(context)!.registerHelpTextCredentials,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20),
          child: Text(
            credentialsError,
            textAlign: TextAlign.left,
            style: const TextStyle(
              color: Colors.red,
            ),
          ),
        ),
      ]),
    ];

    return LoaderOverlay(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 25),
              child: Row(
                children: _buildScreenIndicator(context),
              ),
            ),
            Expanded(child: inputSreens.elementAt(_curScreen - 1)),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              const Spacer(),
              const Spacer(),
              Visibility(
                visible: _curScreen != 1,
                child: ElevatedButton(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Text(AppLocalizations.of(context)!.btnBack),
                  ),
                  onPressed: () {
                    if (_curScreen == Screens.name) return;
                    setState(() {
                      _curScreen--;
                    });
                  },
                ),
              ),
              const Spacer(),
              Visibility(
                visible: _curScreen != inputSreens.length,
                child: ElevatedButton(
                  style: (_curScreen == Screens.name &&
                              isValidName &&
                              acceptedTAC ||
                          _curScreen == Screens.birthdate && isValidDate ||
                          _curScreen == Screens.codex ||
                          _curScreen == Screens.credentials &&
                              areValidCredentials)
                      ? null
                      : const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.grey),
                          overlayColor: MaterialStatePropertyAll(Colors.grey),
                        ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: _curScreen == Screens.codex
                        ? Text(AppLocalizations.of(context)!.accept)
                        : Text(AppLocalizations.of(context)!.btnNext),
                  ),
                  onPressed: () {
                    if (_curScreen == inputSreens.length) return;

                    switch (_curScreen) {
                      case Screens.name:
                        if (!isValidName || !acceptedTAC) return;
                        break;
                      case Screens.birthdate:
                        if (!isValidDate) return;
                        break;
                    }
                    setState(() {
                      _curScreen++;
                    });
                  },
                ),
              ),
              Visibility(
                visible: _curScreen == inputSreens.length,
                child: ElevatedButton(
                  style: _curScreen == Screens.credentials &&
                          areValidCredentials
                      ? null
                      : const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.grey),
                          overlayColor: MaterialStatePropertyAll(Colors.grey),
                        ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Text(AppLocalizations.of(context)!.finish),
                  ),
                  onPressed: () async {
                    if (_curScreen != inputSreens.length ||
                        _curScreen != Screens.credentials ||
                        !areValidCredentials) return;

                    context.loaderOverlay.show();
                    try {
                      await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                              email: email.toLowerCase(), password: password);
                    } on FirebaseAuthException catch (e) {
                      setState(() {
                        switch (e.code) {
                          case 'network-request-failed':
                            credentialsError = AppLocalizations.of(context)!
                                .exceptionNetworkRequestFailed;
                            break;
                          case 'email-already-in-use':
                            credentialsError = AppLocalizations.of(context)!
                                .exceptionAccountAlreadyExists;
                            break;
                          case 'invalid-email':
                            credentialsError = AppLocalizations.of(context)!
                                .exceptionInvalidEmail;
                            break;
                          case 'weak-password':
                            credentialsError = AppLocalizations.of(context)!
                                .exceptionWeakPassword;
                            break;
                          default:
                            credentialsError = AppLocalizations.of(context)!
                                .unexpectedErrorOccured;
                        }

                        context.loaderOverlay.hide();
                      });

                      // TODO send name and bday as well
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Screens {
  static const int name = 1;
  static const int birthdate = 2;
  static const int codex = 3;
  static const int credentials = 4;

  static const int total = 4;
}

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
              return _validateName(context, value ?? '');
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
                // TODO link to AGBs
                var url = Uri.parse('https://social-dex.com');
                if (!await canLaunchUrl(url)) {
                  // TODO message
                  return;
                }
                await launchUrl(url);
                // ignore: use_build_context_synchronously
                context.loaderOverlay.hide();
              },
            ),
            const Spacer(),
          ],
        ),
      ],
    );
  }
}

String? _validateName(BuildContext context, String value) {
  if (value.isEmpty) {
    return AppLocalizations.of(context)!.nameCantBeEmpty;
  }
  return null;
}

class BirthDateScreen extends StatelessWidget {
  final TextEditingController cYear;
  final TextEditingController cMonth;
  final TextEditingController cDay;

  const BirthDateScreen({
    super.key,
    required this.cYear,
    required this.cMonth,
    required this.cDay,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 60, left: 30, right: 30),
            child: Text(
              AppLocalizations.of(context)!.registerHelpTextBDay,
            ),
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(bottom: 30, left: 40, right: 40),
          child: BDayPicker(
            cYear: cYear,
            cMonth: cMonth,
            cDay: cDay,
          ),
        ),
        const Spacer(),
      ],
    );
  }
}

class CodexScreen extends StatelessWidget {
  const CodexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: Column(
          children: [
            const Spacer(),
            Expanded(
              child: Text(
                '✌️ ${AppLocalizations.of(context)!.codexRespect}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Expanded(
              child: Text(
                '🕵️ ${AppLocalizations.of(context)!.codexPrivacy}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Expanded(
              child: Text(
                '😇 ${AppLocalizations.of(context)!.codexAuthenticity}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
