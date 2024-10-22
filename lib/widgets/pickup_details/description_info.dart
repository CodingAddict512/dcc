import 'package:dcc/models/pickup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DescriptionInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pickup = Provider.of<Pickup>(context);

    if (pickup.description == null) {
      return Container();
    }

    return ListTile(
      leading: Icon(Icons.subject),
      title: Text(pickup.description),
    );
  }
}
