import 'package:dcc/models/pickup_route.dart';

abstract class IRoutesRepository {
  Stream<PickupRoute> getRoute(String routeId);
  Future<void> setRoute(PickupRoute route);

  Stream<List<PickupRoute>> getRoutes(String driverId);
}
