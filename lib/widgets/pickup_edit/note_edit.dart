import 'package:dcc/cubits/pickup_edit_cubit.dart';
import 'package:dcc/cubits/states/pickup_edit_state.dart';
import 'package:dcc/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:dcc/extensions/compat.dart';

class NoteEdit extends StatelessWidget {
  final TextEditingController noteController;
  NoteEdit({this.noteController});

  @override
  Widget build(BuildContext context) {
    final pickupEditCubit = context.watch<PickupEditCubit>();

    pickupEditCubit.state.ifState<PickupEditLoaded>(withState: (state) {
      noteController?.text = state.note;
    });

    return ListTile(
      leading: Icon(Icons.comment),
      title: TextFormField(
        maxLines: null,
        controller: noteController,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          hintText: DccLocalizations.of(context).translate("noteButtonLabelAddNote"),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
