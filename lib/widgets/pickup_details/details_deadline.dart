import 'package:flutter/material.dart';

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
