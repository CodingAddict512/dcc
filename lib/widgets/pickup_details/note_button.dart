import 'package:dcc/cubits/pickups_cubit.dart';
import 'package:dcc/localization/app_localizations.dart';
import 'package:dcc/models/pickup.dart';
import 'package:dcc/models/status.dart';
import 'package:dcc/widgets/pickup_details/note_edit_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NoteButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pickup = Provider.of<Pickup>(context);
    final pickupsCubit = Provider.of<PickupsCubit>(context);
    final localizations = DccLocalizations.of(context);

    void onNotePress() async {
      final result = await showDialog(
        context: context,
        builder: (context) => NoteEditDialog(initialText: pickup.note ?? ""),
      );
      if (result is String) {
        pickupsCubit.editNote(result);
      }
    }

    if (pickup.note == null || pickup.note.length == 0) {
      return ElevatedButton.icon(
        onPressed: pickup.status != Status.STARTED ? null : onNotePress,
        icon: Icon(Icons.add_comment),
        label: Text(localizations!.translate("noteButtonLabelAddNote")),
      );
    }

    return ElevatedButton.icon(
      onPressed: pickup.status != Status.STARTED ? null : onNotePress,
      icon: Icon(Icons.comment),
      label: Text(localizations!.translate("noteButtonLabelEditNote")),
    );
  }
}
