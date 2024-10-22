import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'location.freezed.dart';

@freezed
abstract class Location implements _$Location {
  Location._();

  factory Location({
    final String id,
    final String name,
    final GeoPoint geoPoint,
  }) = _Location;

  static Future<Location> fromReference(DocumentReference reference) async {
    final snapshot = await reference.get();

    return snapshot.exists ? Location.fromMap(snapshot.data(), reference.id) : null;
  }

  factory Location.fromMap(Map<String, dynamic> data, String documentId) {
    return Location(
      id: documentId,
      name: data["name"],
      geoPoint: data["geoLocation"],
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'id': id,
      'name': name,
      'geoLocation': geoPoint,
      'isActive': true,
    } as Map<String, dynamic>;
  }
}
