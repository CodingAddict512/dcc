import 'dart:io';

import 'package:dcc/data/firebase_storage/firebase_storage_helper.dart';
import 'package:dcc/data/firebase_storage/firebase_storage_path.dart';
import 'package:dcc/data/firestore/firestore_service.dart';
import 'package:dcc/data/respository_interface.dart';
import 'package:dcc/data/shared_preferences/shared_preferences_service.dart';
import 'package:dcc/models/car.dart';
import 'package:dcc/models/customer.dart';
import 'package:dcc/models/customer_stub.dart';
import 'package:dcc/models/location.dart';
import 'package:dcc/models/transporter.dart';
import 'package:path/path.dart' as p;

class Repository implements IRepository {
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
  Stream<Transporter> getTransporter(String transporterId) {
    return FirestoreService.transporterStream(transporterId: transporterId);
  }

  /* Location */

  Stream<List<Location>> getLocations(String customerId) => FirestoreService.locationsStream(customerId: customerId);

  /* Default Location */
  Stream<List<CustomerStub>> getCustomerStubs() => FirestoreService.customerStubsStream();

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
