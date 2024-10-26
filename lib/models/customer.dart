import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dcc/models/location.dart';
import 'package:dcc/models/status.dart';

class Customer {
  final String id;
  final String name;
  final Location primaryLocation;
  final String streetName;
  final String streetBuildingIdentifier;
  final String postCodeIdentifier;
  final String districtName;
  final String certificateAbNr;
  final String notes;

  Customer({
    required this.id,
    required this.name,
    required this.primaryLocation,
    required this.streetName,
    required this.streetBuildingIdentifier,
    required this.postCodeIdentifier,
    required this.districtName,
    required this.certificateAbNr,
    required this.notes,
  });

  static Future<Customer> fromMap(
    Map<String, dynamic> data,
    String documentId,
  ) async {
    final Location primaryLocation = data["primaryLocation"] != null
        ? await Location.fromReference(data["primaryLocation"]) ??
            (throw Exception("primaryLocation could not be resolved"))
        : throw Exception("primaryLocation is required but missing");

    return Customer(
      id: documentId,
      name: data["name"] ?? "",
      primaryLocation: primaryLocation,
      streetName: data["streetName"] ?? "",
      streetBuildingIdentifier: data["streetBuildingIdentifier"] ?? "",
      postCodeIdentifier: data["postCodeIdentifier"] ?? "",
      districtName: data["districtName"] ?? "",
      certificateAbNr: data["certificateAbNr"] ?? "",
      notes: data["notes"] ?? "",
    );
  }

  static Future<Customer> fromReference(DocumentReference reference) async {
    final snapshot = await reference.get();
    final data = snapshot.data();

    if (data is Map<String, dynamic>) {
      return Customer.fromMap(data, reference.id);
    } else {
      throw Exception('Customer data is not in the expected format');
    }
  }
}
