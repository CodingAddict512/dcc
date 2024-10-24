import 'package:dcc/extensions/context_localization.dart';
import 'package:dcc/localization/app_localizations.dart';
import 'package:flutter/material.dart';

class LanguageDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = DccLocalizations.of(context);
    final navigator = Navigator.of(context);

    return AlertDialog(
      content: Container(
        width: double.minPositive,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: DccLocalizations.supportedLocales.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () =>
                  navigator.pop(DccLocalizations.supportedLocales[index]),
              title: Text(context.languageCodeToString(
                  DccLocalizations.supportedLocales[index].languageCode)),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => navigator.pop(),
          child: Text(localizations!.translate("settingsPageDialogClose")),
        ),
      ],
    );
  }
}
