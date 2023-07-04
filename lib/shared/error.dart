import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final String errorMessage;

  const ErrorScreen({
    super.key,
    this.errorMessage = '',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Spacer(),
          Icon(
            Icons.warning_rounded,
            size: 200,
            color: Colors.red[300],
          ),
          Text(
            errorMessage == ''
                ? AppLocalizations.of(context)!.unexpectedErrorOccured
                : errorMessage,
            textAlign: TextAlign.center,
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
