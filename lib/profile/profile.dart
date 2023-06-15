import 'package:app/services/auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: const Text('Log out'),
        onPressed: () {
          AuthService().signOut();
        },
      ),
    );
  }
}
