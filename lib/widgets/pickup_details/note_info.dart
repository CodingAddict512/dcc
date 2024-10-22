import 'package:dcc/models/pickup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NoteInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pickup = Provider.of<Pickup>(context);

    if (pickup.note == null || pickup.note.length == 0) {
      return Container();
    }

    return ListTile(
      leading: Icon(Icons.comment),
      title: Text(pickup.note),
    );
  }
}
