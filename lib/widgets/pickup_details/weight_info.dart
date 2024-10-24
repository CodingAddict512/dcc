import 'package:dcc/models/pickup.dart';
import 'package:dcc/widgets/flexible_weight_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WeightInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Pickup pickup = Provider.of<Pickup>(context);

    return ListTile(
      leading: Icon(Icons.storage),
      title: FlexibleWeightInfo(
        amount: pickup.amount,
        actualAmount: pickup.actualAmount,
        metric: pickup.metric,
        actualMetric: pickup.actualMetric,
        weight: pickup.actualRegisteredWeight,
      ),
    );
  }
}
