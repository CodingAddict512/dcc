import 'dart:collection';

import 'package:dcc/localization/app_localizations.dart';
import 'package:dcc/models/customer.dart';
import 'package:dcc/models/pickup.dart';
import 'package:dcc/widgets/pickups/pickup_group.dart';
import 'package:flutter/material.dart';

class PickupsList extends StatelessWidget {
  static const _gapPadding = 8.0;
  final List<Pickup> pickups;

  PickupsList(this.pickups);

  @override
  Widget build(BuildContext context) {
    Map<String, List<Pickup>> customerId2pickups = new HashMap<String, List<Pickup>>();
    Map<String, Customer> customerId2customer = new HashMap<String, Customer>();
    for (Pickup pickup in pickups) {
      String customerId = pickup.originCustomer.id;
      customerId2customer[customerId] = pickup.originCustomer;
      if (customerId2pickups[customerId] == null) {
        customerId2pickups[customerId] = [pickup];
      } else {
        customerId2pickups[customerId].add(pickup);
      }
    }
    List<String> customerIds = customerId2customer.keys.toList();

    if ((pickups?.length ?? 0) > 0) {
      return ListView.builder(
        itemCount: customerIds.length,
        padding: EdgeInsets.all(_gapPadding),
        itemBuilder: (BuildContext context, int index) {
          String customerId = customerIds[index];
          return PickupGroup(customerId2customer[customerId], customerId2pickups[customerId]);
        },
      );
    }

    return Center(
      child: Text(
        DccLocalizations.of(context).translate("pickupsListNoPickups"),
      ),
    );
  }
}
