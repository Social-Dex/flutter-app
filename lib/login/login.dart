import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:app/login/credentials.dart';
import 'package:app/services/auth.dart';
import 'package:flutter/material.dart';

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

  @override
  initState() {
    super.initState();

    cEmail.addListener(() {
      email = cEmail.text;
    });
    cPassword.addListener(() {
      password = cPassword.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.logIn),
      ),
      body: CredentialsScreen(cEmail: cEmail, cPassword: cPassword),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            const Spacer(),
            ElevatedButton(
              child: Text(AppLocalizations.of(context)!.logIn),
              onPressed: () {
                AuthService().signInWithEmail(email: email, password: password);
              },
            ),
          ],
        ),
      ),
    );
  }
}
