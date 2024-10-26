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
  Customer? originCustomer; // Changed to non-final
  Location? originLocation; // Remains final
  Customer? receiverCustomer; // Changed to non-final
  Location? receiverLocation; // Remains final
  final Timestamp collectedTime;
  final String deviceId;
  final FileFormat? externalNHDocFormat;

  Pickup({
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

  // CopyWith method
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

  factory Pickup.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Pickup(
      id: doc.id,
      orderId: data['orderId'] ?? '',
      amount: data['amount'] ?? 0,
      metric: data['metric'] ?? 0,
      metricTypeId: data['metricTypeId'] ?? 0,
      actualAmount: data['actualAmount'] ?? 0,
      actualMetric: data['actualMetric'] ?? 0,
      actualMetricTypeId: data['actualMetricTypeId'] ?? 0,
      actualRegisteredWeight: data['actualRegisteredWeight'] ?? '',
      actualFinalDisposition: data['actualFinalDisposition'] ?? '',
      actualFinalDispositionId: data['actualFinalDispositionId'] ?? 0,
      deadline: data['deadline'] ?? '',
      status: Status.fromString(data["status"]),
      originalStatus: Status.fromString(data['originalStatus'] ?? {}),
      note: data['note'] ?? '',
      description: data['description'] ?? '',
      finalDisposition: data['finalDisposition'] ?? '',
      driverId: data['driverId'] ?? '',
      finalDispositionId: data['finalDispositionId'] ?? 0,
      // route: data['route'] != null ? PickupRoute.fromMap(data['route']) : null,
      route: data['route'] != null
          ? PickupRoute.fromMap(
              data['route'], doc.id) // Pass doc.id as the second argument
          : null,
      originCustomer: null, // Set to null for now
      originLocation: data['originLocation'] != null
          ? Location.fromMap(data['originLocation'], doc.id)
          : null,
      receiverCustomer: null, // Set to null for now
      receiverLocation: data['receiverLocation'] != null
          ? Location.fromMap(data['receiverLocation'], doc.id)
          : null,
      collectedTime: data['collectedTime'] ?? Timestamp.now(),
      deviceId: data['deviceId'] ?? '',
      externalNHDocFormat: data['externalNHDocFormat'] != null
          ? FileFormatExtension.fromString(data['externalNHDocFormat'])
          : null,
    );
  }

  // New static method to handle async loading of customers
  static Future<Pickup> fromFirestoreAsync(DocumentSnapshot doc) async {
    final pickup = Pickup.fromFirestore(doc); // Create a pickup instance
    final data = doc.data() as Map<String, dynamic>;

    // Await for the customer retrieval
    pickup.originCustomer = data['originCustomer'] != null
        ? await Customer.fromMap(data['originCustomer'], doc.id)
        : null;

    pickup.receiverCustomer = data['receiverCustomer'] != null
        ? await Customer.fromMap(data['receiverCustomer'], doc.id)
        : null;

    return pickup;
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
