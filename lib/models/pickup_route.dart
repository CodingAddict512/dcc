import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'pickup_route.freezed.dart';

@freezed
abstract class PickupRoute implements _$PickupRoute {

  PickupRoute._();

  factory PickupRoute({
    final String id,
    final String name,
    final String assignedDriver,
    final bool isActive,
    final String plannedDate,
    @Default([]) final List<DocumentReference> assignedOrders,
    @Default([]) final List<DocumentReference> draftOrders,
    final DocumentReference car,
  }) = _PickupRoute;

  factory PickupRoute.fromMap(Map<String, dynamic> data, String documentId) {
    final assignedOrders =  _asListOfReferences(data["assignedOrders"]);
    final assignedOrderIds = assignedOrders.map((e) => e.id).toSet();
    final draftOrders = _asListOfReferences(data["draftOrders"])
      .where((element) => !assignedOrderIds.contains(element.id))
      .toList();
    return PickupRoute(
      id: documentId,
      name: data["id"].toString(),
      isActive: data["isActive"],
      plannedDate: data["plannedDate"],
      assignedDriver: data["assignedDriver"],
      car: data["car"],
      assignedOrders: assignedOrders,
      draftOrders: draftOrders,
    );
  }

  static Future<PickupRoute> fromReference(DocumentReference reference) async {
    final snapshot = await reference.get();
    return PickupRoute.fromMap(snapshot.data(), reference.id);
  }

  List<DocumentReference> get allOrders => PickupRoute.combinedReferences(
      this.assignedOrders,
      this.draftOrders
  );

  Map<String, dynamic> toMap() {
      final assignedOrderIds = assignedOrders.map((e) => e.id).toSet();
      final draftOrders = new List<DocumentReference>.from(this.draftOrders)
          .where((element) => !assignedOrderIds.contains(element.id))
          .toList();
      if (isCreation()) {
        return {
          "id": name,
          "isActive": isActive,
          "plannedDate": plannedDate,
          "assignedDriver": assignedDriver,
          "assignedOrders": assignedOrders,
          "car": car,
          "draftOrders": draftOrders
        };
      }
      return {
        "draftOrders": draftOrders,
        "isActive": this.isActive,
      };
    }

  bool isCreation() => name == "PENDING" || name == "ERROR";

  static List<DocumentReference> _asListOfReferences(dynamic data) =>
      data
          ?.map<DocumentReference>((d) => d as DocumentReference)
          ?.toList() ?? [];

  static List<DocumentReference> combinedReferences(List<DocumentReference> refs,
      List<DocumentReference> additionalRefs) {
    if (additionalRefs == null || additionalRefs.isEmpty) {
      return refs ?? <DocumentReference>[];
    }
    final knownIds = refs.map((e) => e.id).toSet();
    final combinedList = List<DocumentReference>.from(refs);
    combinedList.addAll(
        additionalRefs.where((element) => !knownIds.contains(element.id))
    );
    return combinedList;
  }
}
