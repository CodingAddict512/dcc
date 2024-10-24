import 'package:dcc/extensions/status.dart';
import 'package:dcc/models/status.dart';
import 'package:dcc/style/dcc_text_styles.dart';
import 'package:flutter/material.dart';

class DetailsStatus extends StatelessWidget {
  final Status status;

  DetailsStatus(this.status);

  @override
  Widget build(BuildContext context) {
    return Text(
      status.name(),
      style: DccTextStyles.pickupDetails.status.copyWith(
        color: status.color(),
      ),
    );
  }
}
