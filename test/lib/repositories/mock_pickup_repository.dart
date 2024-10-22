import 'package:dcc/data/repositories/pickup_repository_interface.dart';
import 'package:dcc/models/pickup.dart';
import 'package:dcc/models/pickup_with_references.dart';
import 'package:rxdart/rxdart.dart';

class MockPickupRepository implements IPickupRepository {
  BehaviorSubject<List<PickupWithReferences>> _pickupsSubject;

  MockPickupRepository({List<PickupWithReferences> pickups}) {
    _pickupsSubject = BehaviorSubject<List<PickupWithReferences>>.seeded(pickups ?? []);
  }

  Stream<List<PickupWithReferences>> getPickupsWithRefs(String driverId, String routeId) {
    return _pickupsSubject.stream;
  }

  Future<PickupWithReferences> setPickup(Pickup pickup) async {
    List<PickupWithReferences> newList = await _pickupsSubject.first;
    PickupWithReferences pickupInList = newList.firstWhere((p) => p.id == pickup.id);

    // Pickup not in list
    if (pickupInList == null) {
      PickupWithReferences pickupWithRefs = null; //TODO: Convert pickup to pickup with references
      newList.add(pickupWithRefs);
      _pickupsSubject.add(newList);
      return pickupWithRefs;
    }

    // Modify pickup
    PickupWithReferences newPickup = pickupInList.copyWith(
      id: pickup.id,
      orderId: pickup.orderId,
      amount: pickup.amount,
      metric: pickup.metric,
      metricTypeId: pickup.metricTypeId,
      actualAmount: pickup.actualAmount,
      actualMetric: pickup.actualMetric,
      actualMetricTypeId: pickup.actualMetricTypeId,
      actualRegisteredWeight: pickup.actualRegisteredWeight,
      actualFinalDisposition: pickup.actualFinalDisposition,
      actualFinalDispositionId: pickup.actualFinalDispositionId,
      deadline: pickup.deadline,
      status: pickup.status,
      originalStatus: pickup.originalStatus,
      note: pickup.note,
      description: pickup.description,
      finalDisposition: pickup.finalDisposition,
      driverId: pickup.driverId,
      finalDispositionId: pickup.finalDispositionId,
      collectedTime: pickup.collectedTime,
      deviceId: pickup.deviceId,
      externalNHDocFormat: pickup.externalNHDocFormat,
    );
    newList.remove(pickupInList);
    newList.add(newPickup);
    _pickupsSubject.add(newList);
    return newPickup;
  }

  Future<void> deletePickup(Pickup pickup) async {
    List<PickupWithReferences> newList = await _pickupsSubject.first;
    newList.removeWhere((p) => p.id == pickup.id);
    _pickupsSubject.add(newList);
  }
}
