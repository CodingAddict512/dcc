import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dcc/extensions/file_format.dart';
import 'package:dcc/extensions/status.dart';
import 'package:dcc/models/file_format.dart';
import 'package:dcc/models/status.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pickup_with_references.freezed.dart';

@freezed
abstract class PickupWithReferences implements _$PickupWithReferences {
  PickupWithReferences._();

  factory PickupWithReferences({
    String id,
    String orderId,
    int amount,
    int metric,
    int metricTypeId,
    int actualAmount,
    int actualMetric,
    int actualMetricTypeId,
    String actualRegisteredWeight,
    String actualFinalDisposition,
    int actualFinalDispositionId,
    Timestamp collectedTime,
    String deviceId,
    String deadline,
    String driverId,
    Status status,
    /* originalStatus is not mapped; it is used to determine how to map.
     * When it is DRAFT then we use a "set" and otherwise we use "update".
     */
    Status originalStatus,
    String note,
    String description,
    String finalDisposition,
    int finalDispositionId,
    DocumentReference route,
    DocumentReference originCustomer,
    DocumentReference originLocation,
    DocumentReference receiverCustomer,
    DocumentReference receiverLocation,
    FileFormat externalNHDocFormat,
  }) = _PickupWithReferences;

  factory PickupWithReferences.fromMap(Map<String, dynamic> data, String documentId) {
    return PickupWithReferences(
        id: documentId,
        orderId: data["orderId"],
        route: data["route"],
        amount: data["amount"],
        metric: data["metric"],
        metricTypeId: data["metricTypeId"],
        actualAmount: data["actualAmount"],
        actualMetric: data["actualMetric"],
        actualMetricTypeId: data["actualMetricTypeId"],
        actualRegisteredWeight: data["actualRegisteredWeight"],
        actualFinalDisposition: data["actualFinalDisposition"],
        actualFinalDispositionId: data["actualFinalDispositionId"],
        collectedTime: data["collectedTime"],
        deviceId: data["deviceId"],
        deadline: data["deadline"],
        driverId: data["driverId"],
        status: Status.values.firstWhere(
          (e) => e.name() == (data["status"] ?? "ASSIGNED"),
          orElse: () => Status.ASSIGNED,
        ),
        /* Starts as the same as status */
        originalStatus: Status.values.firstWhere(
          (e) => e.name() == (data["status"] ?? "ASSIGNED"),
          orElse: () => Status.ASSIGNED,
        ),
        note: data["note"],
        description: data["description"],
        finalDisposition: data["finalDisposition"],
        finalDispositionId: data["finalDispositionId"],
        originLocation: data["originLocation"],
        originCustomer: (data["originLocation"] as DocumentReference)?.parent?.parent,
        receiverLocation: data["receiverLocation"],
        receiverCustomer: (data["receiverLocation"] as DocumentReference)?.parent?.parent,
        externalNHDocFormat: FileFormat.values.firstWhere(
          (e) => e.name() == (data["externalNHDocFormat"] ?? "NONE"),
          orElse: () => FileFormat.NONE,
        ));
  }

  Map<String, dynamic> toMap() {
    if (this.originalStatus == Status.DRAFT) {
      /* Send the full state */
      return {
        "orderId": orderId,
        "route": route,
        "driverId": driverId,
        "amount": amount,
        "metric": metric,
        "metricTypeId": metricTypeId,
        "actualAmount": actualAmount,
        "actualMetric": actualMetric,
        "actualMetricTypeId": actualMetricTypeId,
        "actualRegisteredWeight": actualRegisteredWeight,
        "collectedTime": collectedTime,
        "deviceId": deviceId,
        "deadline": deadline,
        "status": status.name(),
        "note": note,
        "description": description,
        "finalDisposition": finalDisposition,
        "finalDispositionId": finalDispositionId,
        "actualFinalDisposition": actualFinalDisposition,
        "actualFinalDispositionId": actualFinalDispositionId,
        "originLocation": originLocation,
        "receiverLocation": receiverLocation,
        "externalNHDocFormat": externalNHDocFormat.name(),
      };
    }
    return {
      "driverId": driverId,
      "actualAmount": actualAmount,
      "actualMetric": actualMetric,
      "actualMetricTypeId": actualMetricTypeId,
      "actualRegisteredWeight": actualRegisteredWeight,
      "collectedTime": collectedTime,
      "deviceId": deviceId,
      "deadline": deadline,
      "status": status.name(),
      "note": note,
      "description": description,
      "actualFinalDisposition": actualFinalDisposition,
      "actualFinalDispositionId": actualFinalDispositionId,
      "originLocation": originLocation,
      "receiverLocation": receiverLocation,
      "externalNHDocFormat": externalNHDocFormat.name(),
    };
  }
}
