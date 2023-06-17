import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:app/login/credentials.dart';
import 'package:app/register/bday_picker.dart';
import 'package:app/services/auth.dart';
import 'package:app/services/models.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final userData = User();

  int _curScreen = 1;

  final cName = TextEditingController();
  bool isValidName = true; // TODO false setzen

  final TextEditingController cYear = TextEditingController();
  final TextEditingController cMonth = TextEditingController();
  final TextEditingController cDay = TextEditingController();
  final SimpleDate birthDate = SimpleDate();
  bool isValidDate = false;

  final cEmail = TextEditingController();
  final cPassword = TextEditingController();
  String email = '';
  String password = '';

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
        isValidDate = BDayPicker.getValidationError(birthDate) == '';
      });
    });
    cMonth.addListener(() {
      birthDate.month = _getSanitizedDateInput(2, cMonth.text);
      setState(() {
        isValidDate = BDayPicker.getValidationError(birthDate) == '';
      });
    });
    cDay.addListener(() {
      birthDate.day = _getSanitizedDateInput(2, cDay.text);
      setState(() {
        isValidDate = BDayPicker.getValidationError(birthDate) == '';
      });
    });
    cEmail.addListener(() {
      email = cEmail.text;
    });
    cPassword.addListener(() {
      password = cPassword.text;
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
      NameScreen(cName: cName),
      BirthDateScreen(cYear: cYear, cMonth: cMonth, cDay: cDay),
      CredentialsScreen(
        cEmail: cEmail,
        cPassword: cPassword,
        helpText: AppLocalizations.of(context)!.registerHelpTextCredentials,
      ),
      const AGBsScreen(),
    ];

    return Scaffold(
      body: inputSreens.elementAt(_curScreen - 1),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(children: [
                Text(
                  '$_curScreen ',
                ),
                Text(
                  '/ ${inputSreens.length}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ]),
            ),
            const Spacer(),
            Visibility(
              visible: _curScreen != 1,
              child: ElevatedButton(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(AppLocalizations.of(context)!.btnBack),
                ),
                onPressed: () {
                  if (_curScreen == 1) return;
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
                style: (_curScreen == 1 && isValidName ||
                      _curScreen == 2 && isValidDate)
                    ? null
                    : const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.grey),
                      overlayColor: MaterialStatePropertyAll(Colors.grey),
                    ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(AppLocalizations.of(context)!.btnNext),
                ),
                onPressed: () {
                  if (_curScreen == inputSreens.length) return;

                  switch (_curScreen) {
                    case 1:
                      if (!isValidName) return;
                      break;
                    case 2:
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(AppLocalizations.of(context)!.finish),
                ),
                onPressed: () {
                  if (_curScreen != inputSreens.length) return;

                  AuthService()
                      .createUserWithEmail(email: email, password: password);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NameScreen extends StatelessWidget {
  final TextEditingController cName;

  const NameScreen({
    super.key,
    required this.cName,
  });

  @override
  Widget build(BuildContext context) {
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
          padding: const EdgeInsets.only(bottom: 30, left: 40, right: 40),
          child: TextFormField(
            keyboardType: TextInputType.name,
            controller: cName,
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
      ],
    );
  }
}

String? _validateName(BuildContext context, String value) {
  // if (value.isEmpty) {
  //   return AppLocalizations.of(context)!.nameCantBeEmpty;
  // }
  // TODO einkommentieren
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

String? _validateYear(BuildContext context, String value) {
  return null;
}

String? _validateMonth(BuildContext context, String value) {
  return null;
}

String? _validateDay(BuildContext context, String value) {
  return null;
}

class AGBsScreen extends StatelessWidget {
  const AGBsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
