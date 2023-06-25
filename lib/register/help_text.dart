import 'package:flutter/material.dart';

class HelpText extends StatelessWidget {
  final String text;

  const HelpText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 60, left: 30, right: 30),
        child: Text(
          text,
        ),
      ),
    );
  }
}
