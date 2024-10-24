// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dcc/extensions/file_format.dart';
// import 'package:dcc/extensions/status.dart';
// import 'package:dcc/models/file_format.dart';
// import 'package:dcc/models/status.dart';
// import 'package:freezed_annotation/freezed_annotation.dart';

// part 'pickup_with_references.freezed.dart';

// @freezed
// abstract class PickupWithReferences implements _$PickupWithReferences {
//   PickupWithReferences._();

//   factory PickupWithReferences({
//     String id,
//     String orderId,
//     int amount,
//     int metric,
//     int metricTypeId,
//     int actualAmount,
//     int actualMetric,
//     int actualMetricTypeId,
//     String actualRegisteredWeight,
//     String actualFinalDisposition,
//     int actualFinalDispositionId,
//     Timestamp collectedTime,
//     String deviceId,
//     String deadline,
//     String driverId,
//     Status status,
//     /* originalStatus is not mapped; it is used to determine how to map.
//      * When it is DRAFT then we use a "set" and otherwise we use "update".
//      */
//     Status originalStatus,
//     String note,
//     String description,
//     String finalDisposition,
//     int finalDispositionId,
//     DocumentReference route,
//     DocumentReference originCustomer,
//     DocumentReference originLocation,
//     DocumentReference receiverCustomer,
//     DocumentReference receiverLocation,
//     FileFormat externalNHDocFormat,
//   }) = _PickupWithReferences;

//   factory PickupWithReferences.fromMap(Map<String, dynamic> data, String documentId) {
//     return PickupWithReferences(
//         id: documentId,
//         orderId: data["orderId"],
//         route: data["route"],
//         amount: data["amount"],
//         metric: data["metric"],
//         metricTypeId: data["metricTypeId"],
//         actualAmount: data["actualAmount"],
//         actualMetric: data["actualMetric"],
//         actualMetricTypeId: data["actualMetricTypeId"],
//         actualRegisteredWeight: data["actualRegisteredWeight"],
//         actualFinalDisposition: data["actualFinalDisposition"],
//         actualFinalDispositionId: data["actualFinalDispositionId"],
//         collectedTime: data["collectedTime"],
//         deviceId: data["deviceId"],
//         deadline: data["deadline"],
//         driverId: data["driverId"],
//         status: Status.values.firstWhere(
//           (e) => e.name() == (data["status"] ?? "ASSIGNED"),
//           orElse: () => Status.ASSIGNED,
//         ),
//         /* Starts as the same as status */
//         originalStatus: Status.values.firstWhere(
//           (e) => e.name() == (data["status"] ?? "ASSIGNED"),
//           orElse: () => Status.ASSIGNED,
//         ),
//         note: data["note"],
//         description: data["description"],
//         finalDisposition: data["finalDisposition"],
//         finalDispositionId: data["finalDispositionId"],
//         originLocation: data["originLocation"],
//         originCustomer: (data["originLocation"] as DocumentReference).parent.parent,
//         receiverLocation: data["receiverLocation"],
//         receiverCustomer: (data["receiverLocation"] as DocumentReference).parent.parent,
//         externalNHDocFormat: FileFormat.values.firstWhere(
//           (e) => e.name() == (data["externalNHDocFormat"] ?? "NONE"),
//           orElse: () => FileFormat.NONE,
//         ));
//   }

//   Map<String, dynamic> toMap() {
//     if (this.originalStatus == Status.DRAFT) {
//       /* Send the full state */
//       return {
//         "orderId": orderId,
//         "route": route,
//         "driverId": driverId,
//         "amount": amount,
//         "metric": metric,
//         "metricTypeId": metricTypeId,
//         "actualAmount": actualAmount,
//         "actualMetric": actualMetric,
//         "actualMetricTypeId": actualMetricTypeId,
//         "actualRegisteredWeight": actualRegisteredWeight,
//         "collectedTime": collectedTime,
//         "deviceId": deviceId,
//         "deadline": deadline,
//         "status": status.name(),
//         "note": note,
//         "description": description,
//         "finalDisposition": finalDisposition,
//         "finalDispositionId": finalDispositionId,
//         "actualFinalDisposition": actualFinalDisposition,
//         "actualFinalDispositionId": actualFinalDispositionId,
//         "originLocation": originLocation,
//         "receiverLocation": receiverLocation,
//         "externalNHDocFormat": externalNHDocFormat.name(),
//       };
//     }
//     return {
//       "driverId": driverId,
//       "actualAmount": actualAmount,
//       "actualMetric": actualMetric,
//       "actualMetricTypeId": actualMetricTypeId,
//       "actualRegisteredWeight": actualRegisteredWeight,
//       "collectedTime": collectedTime,
//       "deviceId": deviceId,
//       "deadline": deadline,
//       "status": status.name(),
//       "note": note,
//       "description": description,
//       "actualFinalDisposition": actualFinalDisposition,
//       "actualFinalDispositionId": actualFinalDispositionId,
//       "originLocation": originLocation,
//       "receiverLocation": receiverLocation,
//       "externalNHDocFormat": externalNHDocFormat.name(),
//     };
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dcc/extensions/file_format.dart';
import 'package:dcc/extensions/status.dart';
import 'package:dcc/models/file_format.dart';
import 'package:dcc/models/status.dart';

class PickupWithReferences {
  final String id;
  final String orderId;
  final int amount;
  final int metric;
  final int metricTypeId;
  final int actualAmount;
  final int actualMetric;
  final int actualMetricTypeId;
  final String actualRegisteredWeight;
  final String actualFinalDisposition;
  final int actualFinalDispositionId;
  final Timestamp collectedTime;
  final String deviceId;
  final String deadline;
  final String driverId;
  final Status status;
  final Status originalStatus;
  final String note;
  final String description;
  final String finalDisposition;
  final int finalDispositionId;
  final DocumentReference route;
  final DocumentReference originCustomer;
  final DocumentReference originLocation;
  final DocumentReference receiverCustomer;
  final DocumentReference receiverLocation;
  final FileFormat externalNHDocFormat;

  const PickupWithReferences({
    required this.id,
    required this.orderId,
    required this.amount,
    required this.metric,
    required this.metricTypeId,
    required this.actualAmount,
    required this.actualMetric,
    required this.actualMetricTypeId,
    required this.actualRegisteredWeight,
    required this.actualFinalDisposition,
    required this.actualFinalDispositionId,
    required this.collectedTime,
    required this.deviceId,
    required this.deadline,
    required this.driverId,
    required this.status,
    required this.originalStatus,
    required this.note,
    required this.description,
    required this.finalDisposition,
    required this.finalDispositionId,
    required this.route,
    required this.originCustomer,
    required this.originLocation,
    required this.receiverCustomer,
    required this.receiverLocation,
    required this.externalNHDocFormat,
  });

  factory PickupWithReferences.fromMap(
      Map<String, dynamic> data, String documentId) {
    return PickupWithReferences(
      id: documentId,
      orderId: data["orderId"],
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
      originalStatus: Status.values.firstWhere(
        (e) => e.name() == (data["status"] ?? "ASSIGNED"),
        orElse: () => Status.ASSIGNED,
      ),
      note: data["note"],
      description: data["description"],
      finalDisposition: data["finalDisposition"],
      finalDispositionId: data["finalDispositionId"],
      route: data["route"],
      originCustomer:
          (data["originLocation"] as DocumentReference).parent.parent!,
      originLocation: data["originLocation"],
      receiverCustomer:
          (data["receiverLocation"] as DocumentReference).parent.parent!,
      receiverLocation: data["receiverLocation"],
      externalNHDocFormat: FileFormat.values.firstWhere(
        (e) => e.name() == (data["externalNHDocFormat"] ?? "NONE"),
        orElse: () => FileFormat.NONE,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    if (this.originalStatus == Status.DRAFT) {
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
