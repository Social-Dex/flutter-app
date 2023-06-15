import 'package:app/register/bday_picker.dart';
import 'package:app/services/auth.dart';
import 'package:app/services/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final userData = User();

  int _curScreen = 1;

  final cName = TextEditingController();

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
    cEmail.dispose();
    cPassword.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> inputSreens = <Widget>[
      NameScreen(cName: cName),
      const BirthDateScreen(),
      CredentialsScreen(
        cEmail: cEmail,
        cPassword: cPassword,
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
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Text('< Previous'),
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
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Text('Next >'),
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
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Text('Finish'),
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
        const Center(
          child: Padding(
            padding: EdgeInsets.only(top: 60, left: 30, right: 30),
            child: Text(
              'This is how you will appear to other users.',
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
            decoration: const InputDecoration(
              labelText: 'Name',
            ),
            maxLength: 20,
            maxLines: 1,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/login');
          },
          child: const Text(
            'Log in instead',
          ),
        ),
        const Spacer(),
      ],
    );
  }
}

class BirthDateScreen extends StatelessWidget {
  const BirthDateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Center(
          child: Padding(
            padding: EdgeInsets.only(top: 60, left: 30, right: 30),
            child: Text(
              'Please tell us when you were born.',
            ),
          ),
        ),
        Spacer(),
        Padding(
          padding: EdgeInsets.only(bottom: 30, left: 40, right: 40),
          child: BDayPicker(),
        ),
        Spacer(),
      ],
    );
  }
}

class CredentialsScreen extends StatefulWidget {
  final TextEditingController cEmail;
  final TextEditingController cPassword;

  const CredentialsScreen({
    super.key,
    required this.cEmail,
    required this.cPassword,
  });

  @override
  State<CredentialsScreen> createState() =>
      // ignore: no_logic_in_create_state
      _CredentialsScreenState(cEmail, cPassword);
}

class _CredentialsScreenState extends State<CredentialsScreen> {
  _CredentialsScreenState(
    this.cEmail,
    this.cPassword,
  );

  final TextEditingController cEmail;
  final TextEditingController cPassword;

  bool _isPasswordVisible = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Center(
          child: Padding(
            padding: EdgeInsets.only(top: 60, left: 30, right: 30),
            child: Text(
              'Please fill in your credentials to create an account.',
            ),
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(bottom: 30, left: 40, right: 40),
          child: TextFormField(
            controller: cEmail,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email',
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
              labelText: 'Password',
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

class AGBsScreen extends StatelessWidget {
  const AGBsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
