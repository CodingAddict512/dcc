// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:freezed_annotation/freezed_annotation.dart';

// part 'car.freezed.dart';

// @freezed
// abstract class Car implements _$Car {

//   Car._();

//   factory Car({
//     final String id,
//     final String licensePlate,
//     final String shortDescription,
//   }) = _Car;

//   factory Car.fromMap(Map<String, dynamic> data, String documentId) {
//     return Car(
//       id: documentId,
//       licensePlate: data["licensePlate"],
//       shortDescription: data["shortDescription"],
//     );
//   }

//   static Future<Car> fromReference(DocumentReference reference) async {
//     final snapshot = await reference.get();
//     return Car.fromMap(snapshot.data(), reference.id);
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';

class Car {
  final String id;
  final String licensePlate;
  final String shortDescription;

  Car({
    required this.id,
    required this.licensePlate,
    required this.shortDescription,
  });

  factory Car.fromMap(Map<String, dynamic> data, String documentId) {
    return Car(
      id: documentId,
      licensePlate: data['licensePlate'] ?? '',
      shortDescription: data['shortDescription'] ?? '',
    );
  }

  static Future<Car> fromReference(DocumentReference reference) async {
    final snapshot = await reference.get();
    if (snapshot.exists) {
      return Car.fromMap(snapshot.data() as Map<String, dynamic>, reference.id);
    } else {
      throw Exception('Car document does not exist');
    }
  }
}
