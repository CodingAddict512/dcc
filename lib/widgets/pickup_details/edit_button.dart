import 'package:dcc/models/pickup.dart';
import 'package:dcc/models/status.dart';
import 'package:dcc/pages/pickup_edit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pickup = Provider.of<Pickup>(context);
    final pickupStatus = pickup?.status ?? Status.COLLECTED;
    final navigator = Navigator.of(context);

    if (pickupStatus == Status.COLLECTED || pickupStatus == Status.SUBMITTED) {
      return Container();
    }

    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () async {
        await navigator.push(
          MaterialPageRoute(builder: (context) => PickupEdit(pickup)),
        );
      },
    );
  }
}
