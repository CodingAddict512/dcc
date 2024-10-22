import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dcc/data/firestore/firestore_helper.dart';
import 'package:dcc/data/firestore/firestore_path.dart';
import 'package:dcc/extensions/empty_reference.dart';
import 'package:dcc/models/car.dart';
import 'package:dcc/models/customer.dart';
import 'package:dcc/models/customer_stub.dart';
import 'package:dcc/models/final_disposition.dart';
import 'package:dcc/models/location.dart';
import 'package:dcc/models/metric_type.dart';
import 'package:dcc/models/pickup.dart';
import 'package:dcc/models/pickup_route.dart';
import 'package:dcc/models/pickup_with_references.dart';
import 'package:dcc/models/status.dart';
import 'package:dcc/models/transporter.dart';
import 'package:flutter/material.dart';

class FirestoreService {
  //Method to retrieve all route items from the same user based on driver
  static Stream<List<PickupRoute>> routesStream({
    @required String driverId,
  }) {
    return FirestoreHelper.collectionStream(
      path: FirestorePath.routes(),
      queryBuilder: (query) => query.where("assignedDriver", isEqualTo: driverId).where("isActive", isEqualTo: true),
      builder: (data, documentId) => PickupRoute.fromMap(data, documentId),
    );
  }

  //Method to retrieve a routesModel object based on the given driver and route Id
  static Stream<PickupRoute> routeStream({
    @required String routeId,
  }) =>
      FirestoreHelper.documentStream(
        path: FirestorePath.route(routeId),
        builder: (data, documentId) => PickupRoute.fromMap(data, documentId),
      );

  static Future<void> setRoute({
    @required PickupRoute route,
  }) =>
      FirestoreHelper.setData(
        path: FirestorePath.route(route.id),
        data: route.toMap(),
        merge: !route.isCreation(),
      );

  static Stream<List<PickupWithReferences>> pickupsWithPrefsStream({
    @required String driverId,
    @required DocumentReference routeRef,
  }) {
    return FirestoreHelper.collectionStream(
      path: FirestorePath.pickups(),
      queryBuilder: (query) => query.where("driverId", isEqualTo: driverId).where("route", isEqualTo: routeRef),
      builder: (data, documentId) => PickupWithReferences.fromMap(data, documentId),
    );
  }

  static Future<void> setPickupWithRefs({
    @required PickupWithReferences pickup,
  }) =>
      FirestoreHelper.setData(
          path: FirestorePath.pickup(pickup.id),
          data: pickup.toMap(),
          /* When it is no longer a draft, then the backend starts to look
         * at the registration.  Therefore we need to use "update" rather
         * than "set".
         */
          merge: pickup.originalStatus != Status.DRAFT);

  static Future<void> deletePickup({
    @required Pickup pickup,
  }) async =>
      await FirestoreHelper.instance.doc(FirestorePath.pickup(pickup.id)).delete();

  static Future<PickupWithReferences> setPickup({
    @required Pickup pickup,
  }) async {
    final originCustomer = pickup.originCustomer != null
        ? FirestorePath.customer(
            pickup.originCustomer.id,
          )
        : null;
    final originLocation = pickup.originCustomer != null && pickup.originLocation != null
        ? FirestorePath.location(
            pickup.originCustomer.id,
            pickup.originLocation.id,
          )
        : null;
    final receiverCustomer = pickup.receiverCustomer != null
        ? FirestorePath.customer(
            pickup.receiverCustomer.id,
          )
        : null;
    final receiverLocation = pickup.receiverCustomer != null && pickup.receiverLocation != null
        ? FirestorePath.location(
            pickup.receiverCustomer.id,
            pickup.receiverLocation.id,
          )
        : null;
    final route = pickup.route != null ? FirestorePath.route(pickup.route.id) : null;

    // Set locations, if they do not exist in firestore (if current location).
    Future<DocumentReference> originLocationRef() async {
      if (originLocation != null) {
        final ref = FirestoreHelper.instance.doc(originLocation);

        if (!await ref.exists()) {
          await setLocation(
            customerId: pickup.originCustomer.id,
            location: pickup.originLocation,
          );
        }
        return ref;
      }
      return null;
    }

    Future<DocumentReference> receiverLocationRef() async {
      if (receiverLocation != null) {
        final ref = FirestoreHelper.instance.doc(receiverLocation);
        if (!await ref.exists()) {
          await setLocation(
            customerId: pickup.receiverCustomer.id,
            location: pickup.receiverLocation,
          );
        }
        return ref;
      }
      return null;
    }

    final pickupWithRefs = PickupWithReferences(
      id: pickup.id,
      orderId: pickup.orderId,
      route: route != null ? FirestoreHelper.instance.doc(route) : null,
      amount: pickup.amount,
      metric: pickup.metric,
      metricTypeId: pickup.metricTypeId,
      actualAmount: pickup.actualAmount,
      actualMetric: pickup.actualMetric,
      actualMetricTypeId: pickup.actualMetricTypeId,
      actualRegisteredWeight: pickup.actualRegisteredWeight,
      actualFinalDisposition: pickup.actualFinalDisposition,
      actualFinalDispositionId: pickup.actualFinalDispositionId,
      collectedTime: pickup.collectedTime,
      deviceId: pickup.deviceId,
      deadline: pickup.deadline,
      driverId: pickup.driverId,
      status: pickup.status,
      originalStatus: pickup.originalStatus,
      note: pickup.note,
      description: pickup.description,
      finalDisposition: pickup.finalDisposition,
      finalDispositionId: pickup.finalDispositionId,
      originCustomer: originCustomer != null ? FirestoreHelper.instance.doc(originCustomer) : null,
      originLocation: await originLocationRef(),
      receiverCustomer: receiverCustomer != null ? FirestoreHelper.instance.doc(receiverCustomer) : null,
      receiverLocation: await receiverLocationRef(),
      externalNHDocFormat: pickup.externalNHDocFormat,
    );
    await setPickupWithRefs(pickup: pickupWithRefs);
    return pickupWithRefs;
  }

  static Future<void> setLocation({
    @required String customerId,
    @required Location location,
  }) =>
      FirestoreHelper.setData(
        path: FirestorePath.location(
          customerId,
          location.id,
        ),
        data: location.toMap(),
      );

  static Stream<List<Customer>> customersStream() {
    return FirestoreHelper.collectionStream(
      path: FirestorePath.customers(),
      builder: (data, documentId) => Customer.fromMap(data, documentId),
    ).asyncMap((futures) => Future.wait(futures));
  }

  static Stream<List<Car>> carsStream(String transporterId) {
    return FirestoreHelper.collectionStream(
      path: FirestorePath.cars(transporterId),
      queryBuilder: (query) => query.where("isActive", isEqualTo: true),
      builder: (data, documentId) => Car.fromMap(data, documentId),
    );
  }

  static Stream<Transporter> transporterStream({
    @required String transporterId,
  }) {
    return FirestoreHelper.documentStream(
      path: FirestorePath.transporter(transporterId),
      builder: (data, documentId) => Transporter.fromMap(data, documentId),
    );
  }

  static Stream<Customer> customerStream({
    @required String organisation,
    @required String customerId,
  }) {
    return FirestoreHelper.documentStream(
      path: FirestorePath.customer(customerId),
      builder: (data, documentId) => Customer.fromMap(data, documentId),
    ).asyncMap((future) => future);
  }

  static Stream<List<Location>> locationsStream({
    @required String customerId,
  }) =>
      FirestoreHelper.collectionStream(
        path: FirestorePath.locations(customerId),
        queryBuilder: (query) => query.where("isActive", isEqualTo: true),
        builder: (data, documentId) => Location.fromMap(data, documentId),
      );

  static Stream<Location> locationStream({
    @required String organisation,
    @required String customerId,
    @required String locationId,
  }) =>
      FirestoreHelper.documentStream(
        path: FirestorePath.location(customerId, locationId),
        builder: (data, documentId) => Location.fromMap(data, documentId),
      );

  static Stream<List<CustomerStub>> customerStubsStream() {
    return FirestoreHelper.documentStream(
      path: FirestorePath.metadataDefaultLocations(),
      builder: (data, documentID) => data != null ? data["default-locations"] : [],
    ).asyncMap((dls) {
      List<Future<CustomerStub>> dlsFutures =
          dls.map((dl) => dl as Map<String, dynamic>).map<Future<CustomerStub>>((dl) => CustomerStub.fromMap(dl)).toList();
      return Future.wait(dlsFutures);
    });
  }

  static Stream<List<FinalDisposition>> finalDispositionsStream() {
    return FirestoreHelper.documentStream(
      path: FirestorePath.finalDispositions(),
      builder: (data, documentID) => data != null ? data["final-dispositions"] as List<dynamic> : [],
    ).asyncMap((dls) {
      final v = dls.map((e) => e as Map<String, dynamic>).map((e) => FinalDisposition.fromMap(e)).toList();
      return v;
    });
  }

  static Stream<List<MetricType>> metricTypesStream() {
    return FirestoreHelper.documentStream(
      path: FirestorePath.metricTypes(),
      builder: (data, documentID) => data != null ? data["metric-types"] as List<dynamic> : [],
    ).asyncMap((dls) {
      final v = dls.map((e) => e as Map<String, dynamic>).map((e) => MetricType.fromMap(e)).toList();
      return v;
    });
  }
}
