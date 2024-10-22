import 'package:dcc/models/customer.dart';
import 'package:dcc/models/location.dart';
import 'package:dcc/style/dcc_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DetailsCustomer extends StatelessWidget {
  final Customer customer;
  final Location location;

  DetailsCustomer(this.customer, this.location);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Icon(Icons.business),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(customer.name,
                style: DccTextStyles.iconTile.description),
            Text("${customer.streetName} ${customer.streetBuildingIdentifier ?? ''}",
                style: DccTextStyles.iconTile.description),
            Text("${customer.postCodeIdentifier ?? ''} ${customer.districtName ?? ''}",
                style: DccTextStyles.iconTile.description),
            Text(""),
            Text(location.name,
                style: DccTextStyles.iconTile.description),
          ],
        ),
      trailing: Text(
        customer.id,
        style: DccTextStyles.pickupDetails.pickupId
      ),
    );
  }
}
