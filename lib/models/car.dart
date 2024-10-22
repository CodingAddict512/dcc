import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'car.freezed.dart';

@freezed
abstract class Car implements _$Car {

  Car._();

  factory Car({
    final String id,
    final String licensePlate,
    final String shortDescription,
  }) = _Car;

  factory Car.fromMap(Map<String, dynamic> data, String documentId) {
    return Car(
      id: documentId,
      licensePlate: data["licensePlate"],
      shortDescription: data["shortDescription"],
    );
  }

  static Future<Car> fromReference(DocumentReference reference) async {
    final snapshot = await reference.get();
    return Car.fromMap(snapshot.data(), reference.id);
  }
}
