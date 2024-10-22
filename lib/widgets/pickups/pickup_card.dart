import 'package:dcc/cubits/pickups_cubit.dart';
import 'package:dcc/extensions/status.dart';
import 'package:dcc/localization/app_localizations.dart';
import 'package:dcc/models/pickup.dart';
import 'package:dcc/pages/pickup_details.dart';
import 'package:dcc/style/dcc_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:dcc/extensions/compat.dart';

class PickupCard extends StatelessWidget {
  static const _padding = 16.0;
  static const _borderRadius = 8.0;
  static const _borderWidth = 4.0;

  final Pickup pickup;

  PickupCard(this.pickup);

  String notNull(String v) {
    if (v == null) {
      return "";
    }
    return v;
  }

  @override
  Widget build(BuildContext context) {
    final pickupsCubit = context.watch<PickupsCubit>();
    final navigator = Navigator.of(context);

    Widget _thumbnail() {
      final type = pickup.actualFinalDisposition ?? pickup.finalDisposition;
      int amount = pickup.actualAmount;
      int metric = pickup.actualMetric;
      if (amount == null || metric == null) {
        amount = pickup.amount;
        metric = pickup.metric;
      }

      Widget _amountMetric() {
        return Row(
          children: [
            Flexible(
              child: Text(
                "$amount",
                style: DccTextStyles.pickupCard.weight,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              "/",
              style: DccTextStyles.pickupCard.weight,
              overflow: TextOverflow.ellipsis,
            ),
            Flexible(
              child: Text(
                "$metric",
                style: DccTextStyles.pickupCard.weight,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        );
      }

      List<Widget> _weight() {
        if (pickup.actualRegisteredWeight == null) {
          return [];
        } else {
          return [Text(pickup.actualRegisteredWeight)];
        }
      }

      List<Widget> _customer_info(customer, location) {
        var addressLine = "${(customer.streetName)} ${(
            notNull(customer.streetBuildingIdentifier))}"
            .trimRight();
        return [
          Text(
            "${(customer.name)}",
            overflow: TextOverflow.ellipsis,
          ),
          Text(addressLine, overflow: TextOverflow.ellipsis),
          Text(location.name, overflow: TextOverflow.ellipsis),
        ];
      }

      Widget _body = Padding(
        padding: const EdgeInsets.symmetric(
          vertical: _padding,
          horizontal: _padding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$type",
              style: DccTextStyles.pickupCard.type,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              DccLocalizations.of(context).translate("pickupDetailsLabelFrom"),
              style: DccTextStyles.pickupEdit.toFrom,
            ),
            ..._customer_info(pickup.originCustomer, pickup.originLocation),
            Text(""),
            Text(
              DccLocalizations.of(context).translate("pickupDetailsLabelTo"),
              style: DccTextStyles.pickupEdit.toFrom,
            ),
            ..._customer_info(pickup.receiverCustomer, pickup.receiverLocation),
            Text(""),
            _amountMetric(),
            ..._weight(),
            Text(
              pickup.status.name(),
              style: DccTextStyles.pickupCard.status.copyWith(
                color: pickup.status.color(),
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              "Deadline: ${pickup.deadline}",
              style: DccTextStyles.pickupCard.deadline,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      );

      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_borderRadius),
          border: Border.all(
            width: _borderWidth,
            color: pickup.status.color(),
          ),
        ),
        child: _body,
      );
    }

    return InkWell(
      borderRadius: BorderRadius.circular(_borderRadius),
      onTap: () {
        pickupsCubit.selectPickup(pickup);
        navigator.push(
          MaterialPageRoute(
            builder: (context) => PickupDetails(),
          ),
        );
      },
      child: _thumbnail(),
    );
  }
}
