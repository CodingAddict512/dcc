// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:freezed_annotation/freezed_annotation.dart';

// part 'location.freezed.dart';

// @freezed
// abstract class Location implements _$Location {
//   Location._();

//   factory Location({
//     final String id,
//     final String name,
//     final GeoPoint geoPoint,
//   }) = _Location;

//   static Future<Location> fromReference(DocumentReference reference) async {
//     final snapshot = await reference.get();

//     return snapshot.exists ? Location.fromMap(snapshot.data(), reference.id) : null;
//   }

//   factory Location.fromMap(Map<String, dynamic> data, String documentId) {
//     return Location(
//       id: documentId,
//       name: data["name"],
//       geoPoint: data["geoLocation"],
//     );
//   }

//   Map<String, dynamic> toMap() {
//     // ignore: unnecessary_cast
//     return {
//       'id': id,
//       'name': name,
//       'geoLocation': geoPoint,
//       'isActive': true,
//     } as Map<String, dynamic>;
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';

class Location {
  final String id;
  final String name;
  final GeoPoint geoPoint;

  // Constructor with required values
  Location({
    required this.id,
    required this.name,
    required this.geoPoint,
  });

  // Static method to create a Location from a Firestore DocumentReference
  static Future<Location?> fromReference(DocumentReference reference) async {
    final snapshot = await reference.get();

    if (snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>;
      return Location.fromMap(data, reference.id);
    }
    return null; // Return null if the snapshot doesn't exist
  }

  // Factory method to create a Location from a Map
  factory Location.fromMap(Map<String, dynamic> data, String documentId) {
    return Location(
      id: documentId,
      name: data["name"] ?? '',
      geoPoint:
          data["geoLocation"] ?? GeoPoint(0, 0), // Default GeoPoint if null
    );
  }

  // Method to convert a Location instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'geoLocation': geoPoint,
      'isActive': true, // Assuming 'isActive' is always true in this case
    };
  }
}
