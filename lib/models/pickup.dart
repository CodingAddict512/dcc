// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dcc/models/customer.dart';
// import 'package:dcc/models/file_format.dart';
// import 'package:dcc/models/location.dart';
// import 'package:dcc/models/pickup_route.dart';
// import 'package:dcc/models/pickup_with_references.dart';
// import 'package:dcc/models/status.dart';
// import 'package:freezed_annotation/freezed_annotation.dart';

// part 'pickup.freezed.dart';

// @freezed
// abstract class Pickup implements _$Pickup {
//   Pickup._();

//   factory Pickup({
//     final String id,
//     final String orderId,
//     final int amount,
//     final int metric,
//     final int metricTypeId,
//     final int actualAmount,
//     final int actualMetric,
//     final int actualMetricTypeId,
//     final String actualRegisteredWeight,
//     final String actualFinalDisposition,
//     final int actualFinalDispositionId,
//     final String deadline,
//     final Status status,
//     /* originalStatus is not mapped; it is used to determine how to map.
//      * When it is DRAFT then we use a "set" and otherwise we use "update".
//      */
//     final Status originalStatus,
//     final String note,
//     final String description,
//     final String finalDisposition,
//     final String driverId,
//     final int finalDispositionId,
//     final PickupRoute route,
//     final Customer originCustomer,
//     final Location originLocation,
//     final Customer receiverCustomer,
//     final Location receiverLocation,
//     final Timestamp collectedTime,
//     final String deviceId,
//     final FileFormat externalNHDocFormat,
//   }) = _Pickup;

//   static Future<Pickup> fromPickupWithReferences(
//       PickupWithReferences pickupWithReferences) async {
//     return Pickup(
//       id: pickupWithReferences.id,
//       orderId: pickupWithReferences.orderId,
//       amount: pickupWithReferences.amount,
//       metric: pickupWithReferences.metric,
//       metricTypeId: pickupWithReferences.metricTypeId,
//       actualAmount: pickupWithReferences.actualAmount,
//       actualMetric: pickupWithReferences.actualMetric,
//       actualMetricTypeId: pickupWithReferences.actualMetricTypeId,
//       actualRegisteredWeight: pickupWithReferences.actualRegisteredWeight,
//       actualFinalDisposition: pickupWithReferences.actualFinalDisposition,
//       actualFinalDispositionId: pickupWithReferences.actualFinalDispositionId,
//       deadline: pickupWithReferences.deadline,
//       status: pickupWithReferences.status,
//       originalStatus: pickupWithReferences.originalStatus,
//       note: pickupWithReferences.note,
//       collectedTime: pickupWithReferences.collectedTime,
//       deviceId: pickupWithReferences.deviceId,
//       driverId: pickupWithReferences.driverId,
//       description: pickupWithReferences.description,
//       finalDisposition: pickupWithReferences.finalDisposition,
//       finalDispositionId: pickupWithReferences.finalDispositionId,
//       route: pickupWithReferences.route != null
//           ? await PickupRoute.fromReference(pickupWithReferences.route)
//           : null,
//       originCustomer: pickupWithReferences.originCustomer != null
//           ? await Customer.fromReference(pickupWithReferences.originCustomer)
//           : null,
//       originLocation: pickupWithReferences.originLocation != null
//           ? await Location.fromReference(pickupWithReferences.originLocation)
//           : null,
//       receiverCustomer: pickupWithReferences.receiverCustomer != null
//           ? await Customer.fromReference(pickupWithReferences.receiverCustomer)
//           : null,
//       receiverLocation: pickupWithReferences.receiverLocation != null
//           ? await Location.fromReference(pickupWithReferences.receiverLocation)
//           : null,
//       externalNHDocFormat: pickupWithReferences.externalNHDocFormat,
//     );
//   }
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dcc/models/customer.dart';
// import 'package:dcc/models/file_format.dart';
// import 'package:dcc/models/location.dart';
// import 'package:dcc/models/pickup_route.dart';
// import 'package:dcc/models/pickup_with_references.dart';
// import 'package:dcc/models/status.dart';

// class Pickup {
//   final String id;
//   final String orderId;
//   final int amount;
//   final int metric;
//   final int metricTypeId;
//   final int actualAmount;
//   final int actualMetric;
//   final int actualMetricTypeId;
//   final String actualRegisteredWeight;
//   final String actualFinalDisposition;
//   final int actualFinalDispositionId;
//   final String deadline;
//   final Status status;
//   final Status originalStatus;
//   final String note;
//   final String description;
//   final String finalDisposition;
//   final String driverId;
//   final int finalDispositionId;
//   final PickupRoute? route;
//   final Customer? originCustomer;
//   final Location? originLocation;
//   final Customer? receiverCustomer;
//   final Location? receiverLocation;
//   final Timestamp collectedTime;
//   final String deviceId;
//   final FileFormat? externalNHDocFormat;

//   const Pickup({
//     required this.id,
//     required this.orderId,
//     required this.amount,
//     required this.metric,
//     required this.metricTypeId,
//     required this.actualAmount,
//     required this.actualMetric,
//     required this.actualMetricTypeId,
//     required this.actualRegisteredWeight,
//     required this.actualFinalDisposition,
//     required this.actualFinalDispositionId,
//     required this.deadline,
//     required this.status,
//     required this.originalStatus,
//     required this.note,
//     required this.description,
//     required this.finalDisposition,
//     required this.driverId,
//     required this.finalDispositionId,
//     this.route,
//     this.originCustomer,
//     this.originLocation,
//     this.receiverCustomer,
//     this.receiverLocation,
//     required this.collectedTime,
//     required this.deviceId,
//     this.externalNHDocFormat,
//   });

//   static Future<Pickup> fromPickupWithReferences(
//       PickupWithReferences pickupWithReferences) async {
//     return Pickup(
//       id: pickupWithReferences.id,
//       orderId: pickupWithReferences.orderId,
//       amount: pickupWithReferences.amount,
//       metric: pickupWithReferences.metric,
//       metricTypeId: pickupWithReferences.metricTypeId,
//       actualAmount: pickupWithReferences.actualAmount,
//       actualMetric: pickupWithReferences.actualMetric,
//       actualMetricTypeId: pickupWithReferences.actualMetricTypeId,
//       actualRegisteredWeight: pickupWithReferences.actualRegisteredWeight,
//       actualFinalDisposition: pickupWithReferences.actualFinalDisposition,
//       actualFinalDispositionId: pickupWithReferences.actualFinalDispositionId,
//       deadline: pickupWithReferences.deadline,
//       status: pickupWithReferences.status,
//       originalStatus: pickupWithReferences.originalStatus,
//       note: pickupWithReferences.note,
//       collectedTime: pickupWithReferences.collectedTime,
//       deviceId: pickupWithReferences.deviceId,
//       driverId: pickupWithReferences.driverId,
//       description: pickupWithReferences.description,
//       finalDisposition: pickupWithReferences.finalDisposition,
//       finalDispositionId: pickupWithReferences.finalDispositionId,
//       route: pickupWithReferences.route != null
//           ? await PickupRoute.fromReference(pickupWithReferences.route)
//           : null,
//       originCustomer: pickupWithReferences.originCustomer != null
//           ? await Customer.fromReference(pickupWithReferences.originCustomer)
//           : null,
//       originLocation: pickupWithReferences.originLocation != null
//           ? await Location.fromReference(pickupWithReferences.originLocation)
//           : null,
//       receiverCustomer: pickupWithReferences.receiverCustomer != null
//           ? await Customer.fromReference(pickupWithReferences.receiverCustomer)
//           : null,
//       receiverLocation: pickupWithReferences.receiverLocation != null
//           ? await Location.fromReference(pickupWithReferences.receiverLocation)
//           : null,
//       externalNHDocFormat: pickupWithReferences.externalNHDocFormat,
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dcc/models/customer.dart';
import 'package:dcc/models/file_format.dart';
import 'package:dcc/models/location.dart';
import 'package:dcc/models/pickup_route.dart';
import 'package:dcc/models/pickup_with_references.dart';
import 'package:dcc/models/status.dart';

class Pickup {
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
  final String deadline;
  final Status status;
  final Status originalStatus;
  final String note;
  final String description;
  final String finalDisposition;
  final String driverId;
  final int finalDispositionId;
  final PickupRoute? route;
  final Customer? originCustomer;
  final Location? originLocation;
  final Customer? receiverCustomer;
  final Location? receiverLocation;
  final Timestamp collectedTime;
  final String deviceId;
  final FileFormat? externalNHDocFormat;

  const Pickup({
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
    required this.deadline,
    required this.status,
    required this.originalStatus,
    required this.note,
    required this.description,
    required this.finalDisposition,
    required this.driverId,
    required this.finalDispositionId,
    this.route,
    this.originCustomer,
    this.originLocation,
    this.receiverCustomer,
    this.receiverLocation,
    required this.collectedTime,
    required this.deviceId,
    this.externalNHDocFormat,
  });

  // Adding the copyWith method
  Pickup copyWith({
    String? id,
    String? orderId,
    int? amount,
    int? metric,
    int? metricTypeId,
    int? actualAmount,
    int? actualMetric,
    int? actualMetricTypeId,
    String? actualRegisteredWeight,
    String? actualFinalDisposition,
    int? actualFinalDispositionId,
    String? deadline,
    Status? status,
    Status? originalStatus,
    String? note,
    String? description,
    String? finalDisposition,
    String? driverId,
    int? finalDispositionId,
    PickupRoute? route,
    Customer? originCustomer,
    Location? originLocation,
    Customer? receiverCustomer,
    Location? receiverLocation,
    Timestamp? collectedTime,
    String? deviceId,
    FileFormat? externalNHDocFormat,
  }) {
    return Pickup(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      amount: amount ?? this.amount,
      metric: metric ?? this.metric,
      metricTypeId: metricTypeId ?? this.metricTypeId,
      actualAmount: actualAmount ?? this.actualAmount,
      actualMetric: actualMetric ?? this.actualMetric,
      actualMetricTypeId: actualMetricTypeId ?? this.actualMetricTypeId,
      actualRegisteredWeight:
          actualRegisteredWeight ?? this.actualRegisteredWeight,
      actualFinalDisposition:
          actualFinalDisposition ?? this.actualFinalDisposition,
      actualFinalDispositionId:
          actualFinalDispositionId ?? this.actualFinalDispositionId,
      deadline: deadline ?? this.deadline,
      status: status ?? this.status,
      originalStatus: originalStatus ?? this.originalStatus,
      note: note ?? this.note,
      description: description ?? this.description,
      finalDisposition: finalDisposition ?? this.finalDisposition,
      driverId: driverId ?? this.driverId,
      finalDispositionId: finalDispositionId ?? this.finalDispositionId,
      route: route ?? this.route,
      originCustomer: originCustomer ?? this.originCustomer,
      originLocation: originLocation ?? this.originLocation,
      receiverCustomer: receiverCustomer ?? this.receiverCustomer,
      receiverLocation: receiverLocation ?? this.receiverLocation,
      collectedTime: collectedTime ?? this.collectedTime,
      deviceId: deviceId ?? this.deviceId,
      externalNHDocFormat: externalNHDocFormat ?? this.externalNHDocFormat,
    );
  }

  static Future<Pickup> fromPickupWithReferences(
      PickupWithReferences pickupWithReferences) async {
    return Pickup(
      id: pickupWithReferences.id,
      orderId: pickupWithReferences.orderId,
      amount: pickupWithReferences.amount,
      metric: pickupWithReferences.metric,
      metricTypeId: pickupWithReferences.metricTypeId,
      actualAmount: pickupWithReferences.actualAmount,
      actualMetric: pickupWithReferences.actualMetric,
      actualMetricTypeId: pickupWithReferences.actualMetricTypeId,
      actualRegisteredWeight: pickupWithReferences.actualRegisteredWeight,
      actualFinalDisposition: pickupWithReferences.actualFinalDisposition,
      actualFinalDispositionId: pickupWithReferences.actualFinalDispositionId,
      deadline: pickupWithReferences.deadline,
      status: pickupWithReferences.status,
      originalStatus: pickupWithReferences.originalStatus,
      note: pickupWithReferences.note,
      collectedTime: pickupWithReferences.collectedTime,
      deviceId: pickupWithReferences.deviceId,
      driverId: pickupWithReferences.driverId,
      description: pickupWithReferences.description,
      finalDisposition: pickupWithReferences.finalDisposition,
      finalDispositionId: pickupWithReferences.finalDispositionId,
      route: pickupWithReferences.route != null
          ? await PickupRoute.fromReference(pickupWithReferences.route)
          : null,
      originCustomer: pickupWithReferences.originCustomer != null
          ? await Customer.fromReference(pickupWithReferences.originCustomer)
          : null,
      originLocation: pickupWithReferences.originLocation != null
          ? await Location.fromReference(pickupWithReferences.originLocation)
          : null,
      receiverCustomer: pickupWithReferences.receiverCustomer != null
          ? await Customer.fromReference(pickupWithReferences.receiverCustomer)
          : null,
      receiverLocation: pickupWithReferences.receiverLocation != null
          ? await Location.fromReference(pickupWithReferences.receiverLocation)
          : null,
      externalNHDocFormat: pickupWithReferences.externalNHDocFormat,
    );
  }
}
