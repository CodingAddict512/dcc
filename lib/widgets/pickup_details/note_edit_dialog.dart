import 'package:dcc/localization/app_localizations.dart';
import 'package:flutter/material.dart';

class NoteEditDialog extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _noteController = TextEditingController();
  final String initialText;

  NoteEditDialog({this.initialText = ""});

  @override
  Widget build(BuildContext context) {
    final localizations = DccLocalizations.of(context);
    final navigator = Navigator.of(context);
    _noteController.text = initialText;

    return Form(
      key: _formKey,
      child: AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              autofocus: true,
              minLines: 3,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              controller: _noteController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: localizations.translate("noteEditDialogHintAddNote"),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => navigator.pop(),
            child: Text(localizations.translate("noteEditDialogButtonCancel")),
          ),
          TextButton(
            onPressed: () {
              final note = _noteController.text;
              if (note.length == 0) {
                navigator.pop();
              } else {
                navigator.pop(note);
              }
            },
            child: initialText.length == 0
                ? Text(localizations.translate("noteEditDialogButtonSaveNew"))
                : Text(localizations.translate("noteEditDialogButtonSave")),
          ),
        ],
      ),
    );
  }
}
