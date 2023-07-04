import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:app/shared/shared.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:app/register/screens.dart';
import 'package:app/register/name.dart';
import 'package:app/register/bday.dart';
import 'package:app/register/date_picker.dart';
import 'package:app/register/gender.dart';
import 'package:app/register/codex.dart';
import 'package:app/login/credentials.dart';
import 'package:app/services/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app/services/models.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final userProfile = UserProfile();

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
                    color: _isScreenComplete(_curScreen) || _curScreen > i + 1
                        ? Colors.teal
                        : Colors.transparent,
                    border: Border.all(
                      width: 2,
                      color: Colors.teal,
                    ),
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

  bool _isScreenComplete(int screen) {
    switch (screen) {
      case Screens.name:
        return isValidName;
      case Screens.birthdate:
        return isValidDate &&
            cYear.text.isNotEmpty &&
            cMonth.text.isNotEmpty &&
            cDay.text.isNotEmpty;
      case Screens.gender:
        if (gender.toLowerCase() == 'other' && userProfile.gender.isEmpty) {
          return false;
        }
        return true;
      case Screens.codex:
        return acceptedTAC;
      case Screens.credentials:
        return areValidCredentials;
    }

    return false;
  }

  final cName = TextEditingController();
  bool isValidName = false;

  final TextEditingController cYear = TextEditingController();
  final TextEditingController cMonth = TextEditingController();
  final TextEditingController cDay = TextEditingController();
  final SimpleDate birthDate = SimpleDate();
  bool isValidDate = false;

  String gender = 'male';
  final TextEditingController cManualGender = TextEditingController();
  void _onGenderChanged(String gender) {
    setState(() {
      this.gender = gender;
    });
  }

  bool acceptedTAC = false;
  void _onTACChanged(bool value) {
    setState(() {
      acceptedTAC = value;
    });
  }

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
      userProfile.name = cName.text;

      setState(() {
        isValidName = validateName(context, userProfile.name) == null;
      });
    });
    cYear.addListener(() {
      birthDate.year = SimpleDate.getSanitizedDateInput(4, cYear.text);
      setState(() {
        isValidDate = DatePicker.getValidationError(context, birthDate) == '';
      });
    });
    cMonth.addListener(() {
      birthDate.month = SimpleDate.getSanitizedDateInput(2, cMonth.text);
      setState(() {
        isValidDate = DatePicker.getValidationError(context, birthDate) == '';
      });
    });
    cDay.addListener(() {
      birthDate.day = SimpleDate.getSanitizedDateInput(2, cDay.text);
      setState(() {
        isValidDate = DatePicker.getValidationError(context, birthDate) == '';
      });
    });
    cManualGender.addListener(() {
      setState(() {
        userProfile.gender = cManualGender.text;
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
      NameScreen(cName: cName),
      BirthDateScreen(cYear: cYear, cMonth: cMonth, cDay: cDay),
      GenderScreen(
        onGenderChanged: _onGenderChanged,
        cManualGender: cManualGender,
        initGender: gender,
      ),
      CodexScreen(onTACChanged: _onTACChanged, initAccept: acceptedTAC),
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
      useDefaultLoading: false,
      overlayWidget: const Loader(),
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
                  style: _isScreenComplete(_curScreen)
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
                    if (!_isScreenComplete(_curScreen)) return;

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
                              email: email.toLowerCase(), password: password)
                          .then((value) async {
                        userProfile.birthday = birthDate.toString();
                        if (gender != 'other') {
                          userProfile.gender = gender.toLowerCase();
                        }

                        await FirestoreService()
                            .updateUserProfile(userProfile)
                            .then((value) {
                          context.loaderOverlay.hide();
                        });
                      });
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
