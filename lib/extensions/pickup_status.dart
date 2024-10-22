import 'package:dcc/models/pickup_status.dart';
import 'package:flutter/material.dart';

extension PickupStatusExtension on PickupStatus {
  Color color() {
    switch (this) {
      case PickupStatus.PENDING:
        return Colors.lightBlue;
      case PickupStatus.SUBMITTED:
        return Colors.orangeAccent;
      case PickupStatus.DONE:
        return Colors.lightGreen;
    }
    return Colors.black; // We should never get here
  }
}
