import 'package:flutter/material.dart';

class BDayPicker extends StatelessWidget {
  const BDayPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        NumberField(hintText: 'YYYY'),
        Separator(),
        NumberField(hintText: 'MM'),
        Separator(),
        NumberField(hintText: 'DD'),
      ],
    );
  }
}

class NumberField extends StatelessWidget {
  final String hintText;

  const NumberField({
    super.key,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
        maxLines: 1,
        maxLength: hintText.length,
        keyboardType: TextInputType.datetime,
        textAlign: TextAlign.center,
        onChanged: (value) {
          if (value.length == hintText.length) {
            // TODO set focus on next field
          } else if (value.isEmpty) {
            // TODO set input on prev field
          }
        },
        decoration: InputDecoration(
          hintText: hintText,
          counter: Container(),
          alignLabelWithHint: true,
        ),
      ),
    );
  }
}

class Separator extends StatelessWidget {
  const Separator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: Text(
        '-',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
        ),
      ),
    );
  }
}
