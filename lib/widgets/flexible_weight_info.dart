import 'package:flutter/material.dart';

@immutable
class FlexibleWeightInfo extends StatelessWidget {
  final int amount;
  final int actualAmount;
  final int metric;
  final int actualMetric;
  final String weight;

  static const _dividerIndent = 8.0;

  FlexibleWeightInfo({
    this.amount,
    this.actualAmount,
    this.metric,
    this.actualMetric,
    this.weight,
  });

  @override
  Widget build(BuildContext context) {
    int displayAmount = amount;
    int displayMetric = metric;

    List<Widget> oldWeight = [];

    // Actual weight is always the correct weight
    if (actualAmount != null && actualMetric != null) {
      displayAmount = actualAmount;
      displayMetric = actualMetric;

      // If there exists old weight
      if (amount != null &&
          actualAmount != amount &&
          metric != null &&
          actualMetric != metric) {
        oldWeight = [
          Flexible(
            child: Text(
              "$amount",
              style: TextStyle(decoration: TextDecoration.lineThrough),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            "/",
            style: TextStyle(decoration: TextDecoration.lineThrough),
          ),
          Flexible(
            child: Text(
              "$metric",
              style: TextStyle(decoration: TextDecoration.lineThrough),
              overflow: TextOverflow.ellipsis,
            ),
          )
        ];
      }
    }

    List<Widget> weightInfo() {
      if (weight == null) {
        return [];
      } else {
        return [Text("$weight", overflow: TextOverflow.ellipsis)];
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                "$displayAmount",
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              "/",
              overflow: TextOverflow.ellipsis,
            ),
            Flexible(
              child: Text(
                "$displayMetric",
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Divider(indent: _dividerIndent),
            ...oldWeight,
          ],
        ),
        ...weightInfo(),
      ],
    );
  }
}
