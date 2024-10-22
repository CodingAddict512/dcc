import 'package:dcc/data/repositories/routes_repository_interface.dart';
import 'package:dcc/models/pickup_route.dart';
import 'package:rxdart/subjects.dart';

class MockRoutesRepository extends IRoutesRepository {
  BehaviorSubject<List<PickupRoute>> _routesSubject;

  MockRoutesRepository({
    List<PickupRoute> routes,
  }) {
    _routesSubject = BehaviorSubject<List<PickupRoute>>.seeded(routes ?? []);
  }

  Stream<PickupRoute> getRoute(String routeId) {
    return _routesSubject.map((routes) => routes.firstWhere((r) => r.id == routeId));
  }

  Future<void> setRoute(PickupRoute route) async {
    List<PickupRoute> state = await _routesSubject.first;
    int index = state.indexWhere((e) => e.id == route.id);

    if (index == -1) {
      state.add(route);
    } else {
      state[index] = route;
    }
    _routesSubject.add(state);
  }

  Stream<List<PickupRoute>> getRoutes(String driverId) => _routesSubject.stream;
}
