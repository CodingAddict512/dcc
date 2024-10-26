// import 'package:dcc/data/firestore/firestore_service.dart';
// import 'package:dcc/data/repositories/routes_repository_interface.dart';
// import 'package:dcc/models/pickup_route.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dcc/data/firestore/firestore_service.dart';
import 'package:dcc/models/pickup_route.dart';
import 'package:dcc/data/repositories/routes_repository_interface.dart';

class RoutesRepository implements IRoutesRepository {
  final FirebaseFirestore firestore;

  RoutesRepository({required this.firestore});

  @override
  Stream<PickupRoute> getRoute(String routeId) {
    // Implementation for getting a single route by ID
    return FirestoreService.routeStream(routeId: routeId);
  }

  @override
  Future<void> setRoute(PickupRoute route) async {
    return FirestoreService.setRoute(route: route);
  }

  @override
  Stream<List<PickupRoute>> getRoutes(String driverId) {
    // Implementation for getting routes for a specific driver
    return FirestoreService.routesStream(driverId: driverId);
  }

  @override
  Future<void> setRoutes(List<PickupRoute> routes) async {
    // Example implementation for updating multiple routes
    for (var route in routes) {
      // Assuming you have a method to get the document reference for the route
      final docRef = firestore.collection('routes').doc(route.id);
      await docRef.set(route
          .toJson()); // Ensure you have a `toJson` method in your PickupRoute model
    }
  }
}
