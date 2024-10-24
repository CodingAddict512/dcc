import 'package:dcc/cubits/pickups_cubit.dart';
import 'package:dcc/localization/app_localizations.dart';
import 'package:dcc/models/pickup.dart';
import 'package:dcc/models/status.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailsFinishButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pickup = Provider.of<Pickup>(context);
    final pickupsCubit = Provider.of<PickupsCubit>(context);
    final localizations = DccLocalizations.of(context);
    final navigator = Navigator.of(context);

    bool canFinishPickup() {
      // Weight is mandatory for finishing a pickup.
      if ((pickup.actualRegisteredWeight?.trim() ?? "") == "") {
        return false;
      }
      return pickup.status == Status.STARTED ||
          pickup.status == Status.REJECTED;
    }

    Widget finishButton() {
      return ElevatedButton.icon(
        onPressed: canFinishPickup() ? () => pickupsCubit.finishPickup() : null,
        icon: Icon(Icons.done),
        label: Text(
          localizations!.translate("pickupDetailsButtonFinish"),
        ),
      );
    }

    Widget deleteDraftButton() {
      return ElevatedButton.icon(
        onPressed: () {
          pickupsCubit.deleteDraftPickup();
          navigator.pop();
        },
        icon: Icon(Icons.delete_forever),
        label: Text(
          localizations!.translate("pickupDetailsDeleteDraftPickup"),
        ),
      );
    }

    return pickup.status == Status.DRAFT ? deleteDraftButton() : finishButton();
  }
}
