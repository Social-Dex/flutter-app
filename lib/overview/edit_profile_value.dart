import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:app/shared/shared.dart';
import 'package:loader_overlay/loader_overlay.dart';

class EditProfileValue extends StatelessWidget {
  final Function onSubmit;
  final Function onExit;
  final Widget widget;

  const EditProfileValue({
    super.key,
    required this.onSubmit,
    required this.onExit,
    required this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayWidget: const Loader(),
      child: Center(
        child: Container(
          color: Colors.black26.withOpacity(0.2),
          child: Padding(
            padding: EdgeInsets.only(
              left: 10,
              right: 10,
              top: MediaQuery.of(context).size.height * 0.1,
              bottom: MediaQuery.of(context).size.height * 0.1,
            ),
            child:
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: const BorderRadius.all(Radius.circular(4)),
                boxShadow: const <BoxShadow>[BoxShadow(blurRadius: 2)],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          onExit();
                        },
                        icon: const Icon(Icons.arrow_back),
                      ),
                      const Spacer(),
                    ],
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(30),
                    child: widget,
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 20, bottom: 6),
                        child: ElevatedButton(
                          onPressed: () {
                            onSubmit();
                          },
                          child: Text(AppLocalizations.of(context)!.save),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}