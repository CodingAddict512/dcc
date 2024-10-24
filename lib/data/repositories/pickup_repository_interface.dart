import 'package:dcc/models/pickup.dart';
import 'package:dcc/models/pickup_with_references.dart';

abstract class IPickupRepository {
  Stream<List<PickupWithReferences>> getPickupsWithRefs(String driverId, String routeId);

  Future<PickupWithReferences> setPickup(Pickup pickup);

  Future<void> deletePickup(Pickup pickup);
}
