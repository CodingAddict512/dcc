import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dcc/data/firestore/firestore_helper.dart';
import 'package:dcc/data/firestore/firestore_path.dart';
import 'package:dcc/data/firestore/firestore_service.dart';
import 'package:dcc/data/repositories/pickup_repository_interface.dart';
import 'package:dcc/models/pickup.dart';
import 'package:dcc/models/pickup_with_references.dart';

class PickupRepository implements IPickupRepository {
  Stream<List<PickupWithReferences>> getPickupsWithRefs(
      String driverId, String routeId) {
    DocumentReference routeRef =
        FirestoreHelper.instance!.doc(FirestorePath.route(routeId));
    return FirestoreService.pickupsWithPrefsStream(
      driverId: driverId,
      routeRef: routeRef,
    );
  }

  Future<PickupWithReferences> setPickup(Pickup pickup) =>
      FirestoreService.setPickup(pickup: pickup);

  Future<void> deletePickup(Pickup pickup) =>
      FirestoreService.deletePickup(pickup: pickup);
}
