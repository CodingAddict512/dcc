import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailsDeadline extends StatelessWidget {
  final String deadline;

  DetailsDeadline(this.deadline);

  @override
  Widget build(BuildContext context) {

    return ListTile(
      leading: Icon(Icons.schedule),
      title: Text(deadline),
    );
  }
}
