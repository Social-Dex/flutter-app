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

  final TextEditingController cYear = TextEditingController();
  final TextEditingController cMonth = TextEditingController();
  final TextEditingController cDay = TextEditingController();
  final SimpleDate birthDate = SimpleDate();

  final cEmail = TextEditingController();
  final cPassword = TextEditingController();
  String email = '';
  String password = '';

  @override
  initState() {
    super.initState();

    cName.addListener(() {
      userData.name = cName.text;
    });
    cYear.addListener(() {
      birthDate.year = cYear.text as int;
    });
    cMonth.addListener(() {
      birthDate.month = cMonth.text as int;
    });
    cDay.addListener(() {
      birthDate.day = cDay.text as int;
    });
    cEmail.addListener(() {
      email = cEmail.text;
    });
    cPassword.addListener(() {
      password = cPassword.text;
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
                  '${cName.text} $_curScreen ',
                ),
                Text(
                  '/ ${inputSreens.length}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ]),
            ),
            const Spacer(),
            Visibility(
              visible: _curScreen != 1,
              child: ElevatedButton(
                style: _curScreen == 1
                    ? const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.grey),
                        overlayColor: MaterialStatePropertyAll(Colors.grey),
                      )
                    : null,
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(AppLocalizations.of(context)!.btnNext),
                ),
                onPressed: () {
                  if (_curScreen == inputSreens.length) return;

                  if (_curScreen == 3) {
                    // Credentials Screen
                    AuthService()
                        .createUserWithEmail(email: email, password: password);
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

class AGBsScreen extends StatelessWidget {
  const AGBsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
