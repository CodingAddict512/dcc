import 'package:dcc/extensions/status.dart';
import 'package:dcc/localization/app_localizations.dart';
import 'package:dcc/models/customer.dart';
import 'package:dcc/models/pickup.dart';
import 'package:dcc/models/pickup_status.dart';
import 'package:dcc/widgets/pickups/pickup_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PickupGroup extends StatelessWidget {
  static const _gapPadding = 2.0;
  final Customer customer;
  final List<Pickup> pickups;

  PickupGroup(this.customer, this.pickups);
  @override
  Widget build(BuildContext context) {
    Widget _pickupsCardWithDivider(pickup) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: _gapPadding),
        child: PickupCard(pickup),
      );
    }

    Widget _pendingIcon() {
      return Icon(
        Icons.pending_actions_outlined,
        color: Colors.lightBlue,
      );
    }

    Widget _submittedIcon() {
      return Icon(
        Icons.assignment_turned_in_outlined,
        color: Colors.orangeAccent,
      );
    }

    Widget _doneIcon() {
      return Icon(
        Icons.done_all_outlined,
        color: Colors.lightGreen,
      );
    }

    Widget _statusIcon() {
      if (pickups.every((p) => p.status.pickupStatus() == PickupStatus.DONE)) {
        return _doneIcon();
      }
      if (pickups.every((p) =>
          p.status.pickupStatus() == PickupStatus.SUBMITTED ||
          p.status.pickupStatus() == PickupStatus.DONE)) {
        return _submittedIcon();
      }
      return _pendingIcon();
    }

    final pickupsLength = pickups?.length ?? 0;
    if (pickupsLength > 0) {
      return ExpansionTile(
        leading: _statusIcon(),
        title: Text(
          customer.name,
          textAlign: TextAlign.start,
        ),
        initiallyExpanded: true,
        children: pickups.map(_pickupsCardWithDivider).toList(),
      );
    }

    return Center(
      child: Text(
        DccLocalizations.of(context).translate("pickupsListNoPickups"),
      ),
    );
  }
}
