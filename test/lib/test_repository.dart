import 'dart:async';
import 'dart:io';

import 'package:dcc/data/firebase_storage/firebase_storage_helper.dart';
import 'package:dcc/data/firebase_storage/firebase_storage_path.dart';
import 'package:dcc/data/firestore/firestore_service.dart';
import 'package:dcc/data/respository_interface.dart';
import 'package:dcc/data/shared_preferences/shared_preferences_service.dart';
import 'package:dcc/models/car.dart';
import 'package:dcc/models/customer.dart';
import 'package:dcc/models/customer_stub.dart';
import 'package:dcc/models/final_disposition.dart';
import 'package:dcc/models/location.dart';
import 'package:dcc/models/metric_type.dart';
import 'package:dcc/models/pickup.dart';
import 'package:dcc/models/pickup_with_references.dart';
import 'package:dcc/models/transporter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:rxdart/rxdart.dart';

class TestRepository implements IRepository {
  /* User */
  Future<User> signInWithEmailAndPassword(String email, String password) async => null;

  /* Customer */
  Stream<Customer> getCustomer(String organisation, String customerId) {
    return FirestoreService.customerStream(organisation: organisation, customerId: customerId);
  }

  Stream<List<Customer>> getCustomers() => FirestoreService.customersStream();

  Future<List<String>> getRecentCustomerIds() => SharedPreferencesService.getRecentCustomerIds();
  Future<void> setRecentCustomerIds(List<String> value) => SharedPreferencesService.setRecentCustomerIds(value);

  /* Car */
  Stream<List<Car>> getCars(String transporterId) => FirestoreService.carsStream(transporterId);

  /* Transporter */
  BehaviorSubject<Transporter> transporterSubject = BehaviorSubject<Transporter>();

  static Transporter getTransporterByIdForTest(String transporterId) => Transporter(
        id: transporterId,
        name: "Asseco Test Transportation A/S",
        streetName: "Kronprinsessegade 54, 5",
        postCodeIdentifier: "1306",
        districtName: "København K",
      );

  Stream<Transporter> getTransporter(String transporterId) {
    return transporterSubject.stream;
  }

  /* Pickup */
  Future<PickupWithReferences> setPickup(Pickup pickup) => FirestoreService.setPickup(pickup: pickup);

  Future<void> deletePickup(Pickup pickup) => FirestoreService.deletePickup(pickup: pickup);

  /* Final dispositions */
  Stream<List<FinalDisposition>> getFinalDispositions() => FirestoreService.finalDispositionsStream();

  Stream<List<Location>> getLocations(String customerId) => FirestoreService.locationsStream(customerId: customerId);
  /* Default Location */
  Stream<List<CustomerStub>> getCustomerStubs() => FirestoreService.customerStubsStream();

  /* Metric type */
  Stream<List<MetricType>> getMetricTypes() => FirestoreService.metricTypesStream();

  /* Theme mode */
  ThemeMode themeModeState = ThemeMode.system;
  Future<ThemeMode> getThemeMode() async => themeModeState;
  Future<void> setThemeMode(ThemeMode themeMode) async => themeModeState = themeMode;

  /* Language code */
  String languageCodeState = 'en';
  Future<String> getLanguageCode() async => languageCodeState;
  Future<void> setLanguageCode(String languageCode) async => languageCodeState = languageCode;

  /* External NH Document */
  Future<void> uploadNhDocImage(File file, String driverId, String pickupId) async {
    final ext = p.extension(file.path);
    final path = FirebaseStoragePath.nhDoc(driverId, pickupId, ext);

    await FirebaseStorageHelper.uploadFile(file, path);
  }

  Future<File> downloadNhDocImage(String driverId, String pickupId, String ext) async {
    final path = FirebaseStoragePath.nhDoc(driverId, pickupId, ext);
    return FirebaseStorageHelper.downloadFile(path);
  }
}
