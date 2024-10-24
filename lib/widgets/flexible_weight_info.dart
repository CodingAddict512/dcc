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
   required this.amount,
  required  this.actualAmount,
  required  this.metric,
  required  this.actualMetric,
  required  this.weight,
  });

  @override
  Widget build(BuildContext context) {
    int displayAmount = amount;
    int displayMetric = metric;

    List<Widget> oldWeight = [];

    // Actual weight is always the correct weight
    displayAmount = actualAmount;
    displayMetric = actualMetric;

    // If there exists old weight
    if (actualAmount != amount && actualMetric != metric) {
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
  
    List<Widget> weightInfo() {
      return [Text("$weight", overflow: TextOverflow.ellipsis)];
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
