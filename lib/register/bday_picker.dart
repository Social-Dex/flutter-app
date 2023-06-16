import 'package:flutter/material.dart';

class BDayPicker extends StatefulWidget {
  final TextEditingController cYear;
  final TextEditingController cMonth;
  final TextEditingController cDay;

  const BDayPicker({
    super.key,
    required this.cYear,
    required this.cMonth,
    required this.cDay,
  });

  @override
  // ignore: no_logic_in_create_state
  State<BDayPicker> createState() => _BDayPickerState(cYear, cMonth, cDay);
}

class _BDayPickerState extends State<BDayPicker> {
  final TextEditingController cYear;
  final TextEditingController cMonth;
  final TextEditingController cDay;

  _BDayPickerState(this.cYear, this.cMonth, this.cDay);

  final FocusNode fnMonth = FocusNode();
  final FocusNode fnDay = FocusNode();

  @override
  void dispose() {
    super.dispose();

    fnMonth.dispose();
    fnDay.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        NumberField(hintText: 'YYYY', nextField: fnMonth),
        const Separator(),
        NumberField(hintText: 'MM', focusNode: fnMonth, nextField: fnDay),
        const Separator(),
        NumberField(hintText: 'DD', focusNode: fnDay),
      ],
    );
  }
}

class NumberField extends StatelessWidget {
  final String hintText;
  final FocusNode? focusNode;
  final FocusNode? nextField;

  const NumberField({
    super.key,
    required this.hintText,
    this.focusNode,
    this.nextField,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
        focusNode: focusNode,
        maxLines: 1,
        maxLength: hintText.length,
        keyboardType: TextInputType.datetime,
        textAlign: TextAlign.center,
        onChanged: (value) {
          if (nextField != null && value.length == hintText.length) {
            nextField!.requestFocus();
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
    return Expanded(
      child: Text(
        '-',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}
