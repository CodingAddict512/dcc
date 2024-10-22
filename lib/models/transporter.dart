import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'transporter.freezed.dart';

@freezed
abstract class Transporter implements _$Transporter {

  Transporter._();

  factory Transporter({
    final String id,
    final String name,
    final String streetName,
    final String postCodeIdentifier,
    final String districtName,
  }) = _Transporter;

  factory Transporter.fromMap(Map<String, dynamic> data, String documentId) {
    return Transporter(
      id: documentId,
      name: data["name"],
      streetName: data["streetName"],
      postCodeIdentifier: data["postCodeIdentifier"],
      districtName: data["districtName"],
    );
  }
}
