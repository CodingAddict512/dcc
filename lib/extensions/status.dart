import 'package:dcc/extensions/pickup_status.dart';
import 'package:dcc/models/pickup_status.dart';
import 'package:dcc/models/status.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

extension StatusExtension on Status {
  String name() {
    return describeEnum(this);
  }

  bool isInProgress() {
    return this == Status.STARTED
        || this == Status.SUBMITTED
        || this == Status.REJECTED;
  }

  PickupStatus pickupStatus() {
    switch (this) {
      case Status.COLLECTED:
        return PickupStatus.DONE;
      case Status.SUBMITTED:
        return PickupStatus.SUBMITTED;
      default:
        return PickupStatus.PENDING;
    }
  }

  Color color() => this.pickupStatus().color();
}
