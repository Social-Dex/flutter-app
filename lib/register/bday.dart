import 'package:app/register/help_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:app/register/date_picker.dart';
import 'package:flutter/material.dart';

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
        HelpText(AppLocalizations.of(context)!.registerHelpTextBDay),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(bottom: 30, left: 40, right: 40),
          child: DatePicker(
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