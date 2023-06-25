import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:app/services/models.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePicker extends StatefulWidget {
  final TextEditingController cYear;
  final TextEditingController cMonth;
  final TextEditingController cDay;

  const DatePicker({
    super.key,
    required this.cYear,
    required this.cMonth,
    required this.cDay,
  });

  static String getValidationError(BuildContext context, SimpleDate date) {
    var realDate = DateTime(date.year, date.month, date.day);

    if (date.year != realDate.year ||
        date.month != realDate.month ||
        date.day != realDate.day) {
      return AppLocalizations.of(context)!.invalidDate;
    }

    var now = DateTime.now();
    Duration diff = now.difference(realDate);

    if (diff.isNegative) {
      return AppLocalizations.of(context)!.invalidDate;
    }

    // = 120 years
    if (diff.inDays >= 43800) {
      return AppLocalizations.of(context)!.notThatOld;
    }

    String datePattern = "yyyy-MM-dd";
    DateTime birthDate = DateFormat(datePattern).parse(date.toString());

    DateTime adultDate = DateTime(
      birthDate.year + 18,
      birthDate.month,
      birthDate.day,
    );

    if (!adultDate.isBefore(now)) {
      return AppLocalizations.of(context)!.mustBe18;
    }

    return '';
  }

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  final FocusNode fnYear = FocusNode();
  final FocusNode fnMonth = FocusNode();
  final FocusNode fnDay = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            NumberField(
                hintText: 'YYYY',
                labelText: AppLocalizations.of(context)!.year,
                controller: widget.cYear,
                focusNode: fnYear,
                nextField: fnMonth),
            const Separator(),
            NumberField(
                hintText: 'MM',
                labelText: AppLocalizations.of(context)!.month,
                controller: widget.cMonth,
                focusNode: fnMonth,
                nextField: fnDay),
            const Separator(),
            NumberField(
                hintText: 'DD',
                labelText: AppLocalizations.of(context)!.day,
                controller: widget.cDay,
                focusNode: fnDay),
          ],
        ),
        Row(
          children: [
            ErrorText(
              cYear: widget.cYear,
              cMonth: widget.cMonth,
              cDay: widget.cDay,
            ),
            const Spacer(),
          ],
        ),
      ],
    );
  }
}

class NumberField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final FocusNode focusNode;
  final FocusNode? nextField;

  const NumberField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.labelText,
    required this.focusNode,
    this.nextField,
  });

  @override
  State<NumberField> createState() => _NumberFieldState();
}

class _NumberFieldState extends State<NumberField> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        maxLines: 1,
        maxLength: widget.hintText.length,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        onChanged: (value) {
          if (widget.nextField != null &&
              value.length == widget.hintText.length) {
            widget.nextField!.requestFocus();
          }
        },
        decoration: InputDecoration(
          labelText: widget.focusNode.hasFocus ? widget.labelText : null,
          hintText: widget.hintText,
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

class ErrorText extends StatefulWidget {
  final TextEditingController cYear;
  final TextEditingController cMonth;
  final TextEditingController cDay;

  const ErrorText({
    super.key,
    required this.cYear,
    required this.cMonth,
    required this.cDay,
  });

  @override
  State<ErrorText> createState() => _ErrorTextState();
}

class _ErrorTextState extends State<ErrorText> {
  String errorText = '';
  SimpleDate date = SimpleDate.fromString(date: '0000-00-00');

  @override
  initState() {
    super.initState();

    widget.cYear.addListener(() {
      String value = widget.cYear.text;
      date.year = _getSanitizedInput(4, value);
      _setErrorText(DatePicker.getValidationError(context, date));
    });
    widget.cMonth.addListener(() {
      String value = widget.cMonth.text;
      date.month = _getSanitizedInput(2, value);
      _setErrorText(DatePicker.getValidationError(context, date));
    });
    widget.cDay.addListener(() {
      String value = widget.cDay.text;
      date.day = _getSanitizedInput(2, value);
      _setErrorText(DatePicker.getValidationError(context, date));
    });
  }

  int _getSanitizedInput(int length, String? value) {
    if (value == null || value.isEmpty) {
      return 1;
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      setState(() {
        errorText = AppLocalizations.of(context)!.invalid;
      });
      return 1;
    }

    if (value.toString().length > length) {
      return int.parse(value.substring(0, length));
    }

    return int.parse(value);
  }

  void _setErrorText(String errorText) {
    setState(() {
      this.errorText = errorText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      errorText,
      textAlign: TextAlign.left,
      style: const TextStyle(
        color: Colors.red,
      ),
    );
  }
}
