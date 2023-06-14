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

  @override
  initState() {
    super.initState();
    cName.addListener(() {
      userData.name = cName.text;
    });
  }

  @override
  void dispose() {
    super.dispose();
    cName.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> inputSreens = <Widget>[
      NameScreen(cName: cName),
      const BirthDateScreen(),
      const CredentialsScreen(),
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
              'We need this information to verify your age. It will also be visible to other users',
            ),
          ),
        ),
        Spacer(),
        Padding(
          padding: EdgeInsets.only(bottom: 30, left: 40, right: 40),
          child: Row(
            children: [
              // TODO create fancy dialer YYYY-MM-DD
            ],
          ),
        ),
      ],
    );
  }
}

class CredentialsScreen extends StatelessWidget {
  const CredentialsScreen({super.key});

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
            decoration: const InputDecoration(
              labelText: 'Email',
            ),
            maxLines: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 30, left: 40, right: 40),
          child: TextFormField(
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
            ),
            maxLines: 1,
          ),
        ),
        const Spacer(),
      ],
    );
  }
}