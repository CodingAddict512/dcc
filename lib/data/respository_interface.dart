import 'dart:io';

import 'package:dcc/models/car.dart';
import 'package:dcc/models/customer.dart';
import 'package:dcc/models/customer_stub.dart';
import 'package:dcc/models/location.dart';
import 'package:dcc/models/transporter.dart';

abstract class IRepository {
  /* Customer */
  Stream<Customer> getCustomer(String organisation, String customerId);

  Stream<List<Customer>> getCustomers();

  Future<List<String>> getRecentCustomerIds();
  Future<void> setRecentCustomerIds(List<String> value);

  /* Car */
  Stream<List<Car>> getCars(String transporterId);

  /* Transporter */
  Stream<Transporter> getTransporter(String transporterId);

  /* Location */
  Stream<List<Location>> getLocations(String customerId);

  /* Default Location */
  Stream<List<CustomerStub>> getCustomerStubs();

  /* External NH Document */
  Future<void> uploadNhDocImage(File file, String driverId, String pickupId);
  Future<File> downloadNhDocImage(String driverId, String pickupId, String ext);
}
