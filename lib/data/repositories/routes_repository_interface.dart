import 'package:dcc/models/pickup_route.dart';

abstract class IRoutesRepository {
  Stream<PickupRoute> getRoute(String routeId);
  Future<void> setRoute(PickupRoute route);

  Future<void> setRoutes(List<PickupRoute> routes);

  Stream<List<PickupRoute>> getRoutes(String driverId);
}

// abstract class IRoutesRepository {
//   Stream<PickupRoute> getRoute(String routeId);
//   Future<void> setRoute(PickupRoute route);

//   // New method to update multiple routes
//   Future<void> setRoutes(List<PickupRoute> routes);

//   Stream<List<PickupRoute>> getRoutes(String driverId);
// }
