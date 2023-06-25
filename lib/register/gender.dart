import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:app/register/help_text.dart';

class GenderScreen extends StatefulWidget {
  final Function(String value) onGenderChanged;
  final TextEditingController cManualGender;
  final String initGender;

  const GenderScreen({
    super.key,
    required this.onGenderChanged,
    required this.cManualGender,
    required this.initGender,
  });

  @override
  State<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
  String gender = 'male';
  FocusNode manualGender = FocusNode();

  @override
  Widget build(BuildContext context) {
    gender = widget.initGender;

    return Column(children: [
      HelpText(AppLocalizations.of(context)!.howDoYouIdentify),
      const Spacer(),
      Center(
        child: SizedBox(
          width: 250,
          child: DropdownButtonFormField(
            value: gender,
            items: [
              DropdownMenuItem(
                value: 'male',
                child: Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.male,
                    ),
                    const Icon(Icons.male, color: Colors.teal),
                  ],
                ),
              ),
              DropdownMenuItem(
                value: 'female',
                child: Row(
                  children: [
                    Text(AppLocalizations.of(context)!.female),
                    const Icon(Icons.female, color: Colors.teal),
                  ],
                ),
              ),
              DropdownMenuItem(
                value: 'other',
                child: Row(
                  children: [
                    Text(AppLocalizations.of(context)!.other),
                    const Icon(Icons.transgender, color: Colors.teal),
                  ],
                ),
              ),
            ],
            onChanged: (gender) {
              if (gender == null) return;

              setState(() {
                this.gender = gender;

                if (this.gender == 'other') {
                  manualGender.requestFocus();
                }

                widget.onGenderChanged(gender);
              });
            },
          ),
        ),
      ),
      gender == 'other'
          ? Padding(
              padding: const EdgeInsets.only(top: 25),
              child: SizedBox(
                width: 300,
                child: TextFormField(
                  controller: widget.cManualGender,
                  focusNode: manualGender,
                  textCapitalization: TextCapitalization.words,
                  maxLines: 1,
                  maxLength: 20,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.yourGender,
                  ),
                ),
              ),
            )
          : Container(),
      const Spacer(),
    ]);
  }
}
