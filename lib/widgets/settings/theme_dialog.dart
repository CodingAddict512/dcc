import 'package:dcc/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:dcc/extensions/context_localization.dart';

class ThemeDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = DccLocalizations.of(context);
    final navigator = Navigator.of(context);

    return AlertDialog(
      content: Container(
        width: double.minPositive,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: ThemeMode.values.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () => navigator.pop(ThemeMode.values[index]),
              title: Text(context.themeModeToString(ThemeMode.values[index])),
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
