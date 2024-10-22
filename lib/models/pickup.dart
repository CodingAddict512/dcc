import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dcc/models/customer.dart';
import 'package:dcc/models/file_format.dart';
import 'package:dcc/models/location.dart';
import 'package:dcc/models/pickup_route.dart';
import 'package:dcc/models/pickup_with_references.dart';
import 'package:dcc/models/status.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pickup.freezed.dart';

@freezed
abstract class Pickup implements _$Pickup {
  Pickup._();

  factory Pickup({
    final String id,
    final String orderId,
    final int amount,
    final int metric,
    final int metricTypeId,
    final int actualAmount,
    final int actualMetric,
    final int actualMetricTypeId,
    final String actualRegisteredWeight,
    final String actualFinalDisposition,
    final int actualFinalDispositionId,
    final String deadline,
    final Status status,
    /* originalStatus is not mapped; it is used to determine how to map.
     * When it is DRAFT then we use a "set" and otherwise we use "update".
     */
    final Status originalStatus,
    final String note,
    final String description,
    final String finalDisposition,
    final String driverId,
    final int finalDispositionId,
    final PickupRoute route,
    final Customer originCustomer,
    final Location originLocation,
    final Customer receiverCustomer,
    final Location receiverLocation,
    final Timestamp collectedTime,
    final String deviceId,
    final FileFormat externalNHDocFormat,
  }) = _Pickup;

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
