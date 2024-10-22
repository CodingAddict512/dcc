import 'package:dcc/data/firestore/firestore_service.dart';
import 'package:dcc/data/repositories/routes_repository_interface.dart';
import 'package:dcc/models/pickup_route.dart';

class RoutesRepository implements IRoutesRepository {
  Stream<PickupRoute> getRoute(String routeId) => FirestoreService.routeStream(routeId: routeId);
  Future<void> setRoute(PickupRoute route) => FirestoreService.setRoute(route: route);

  Stream<List<PickupRoute>> getRoutes(String driverId) => FirestoreService.routesStream(driverId: driverId);
}
