import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:app/services/models.dart';
import 'package:app/services/auth.dart';

class ProfileScreen extends StatefulWidget {
  final UserProfile profile;

  const ProfileScreen({
    super.key,
    required this.profile,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60),
      child: Center(
        child: Column(
          children: [
            const Spacer(),
            Row(children: [
              const Text('Name:'),
              const Spacer(),
              Text(widget.profile.name),
            ]),
            Row(children: [
              const Text('Birthday:'),
              const Spacer(),
              Text(widget.profile.birthday),
            ]),
            Row(children: [
              const Text('Gender:'),
              const Spacer(),
              Text(widget.profile.gender),
            ]),
            Row(children: [
              const Text('Email:'),
              const Spacer(),
              Text(AuthService().user!.email!),
            ]),
            const Spacer(),
            ElevatedButton(
              child: Text(AppLocalizations.of(context)!.logOut),
              onPressed: () {
                AuthService().signOut();
              },
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
