import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/loading_animation.gif',
        width: (MediaQuery.of(context).size.width) * 0.6,
      ),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(7, 34, 79, 1),
      body: Center(
        child: Image.asset('assets/logo_with_text.png'),
      ),
    );
  }
}
