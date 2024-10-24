import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dcc/models/customer.dart';

class CustomerStub {
  final String customerName;
  final bool isDefaultReceiver;
  final DocumentReference customerUnresolved;
  final GeoPoint geoLocation;

  CustomerStub(
      {required this.customerName,
      required this.customerUnresolved,
      required this.isDefaultReceiver,
      required this.geoLocation});

  Future<Customer> resolveCustomer() async {
    return await Customer.fromReference(this.customerUnresolved);
  }

  static Future<CustomerStub> fromMap(Map<String, dynamic> data) async {
    return CustomerStub(
      customerName: data["customerName"],
      customerUnresolved: data["customer"],
      geoLocation: data["geoLocation"],
      isDefaultReceiver: data["isDefaultReceiver"] ?? false,
    );
  }
}
