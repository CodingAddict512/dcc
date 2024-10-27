import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dcc/cubits/states/routes_state.dart';
import 'package:dcc/cubits/user_cubit.dart';
import 'package:dcc/data/firestore/firestore_path.dart';
import 'package:dcc/data/repositories/routes_repository_interface.dart';
import 'package:dcc/models/pickup.dart';
import 'package:dcc/models/pickup_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/firestore/firestore_helper.dart';
import 'states/user_state.dart';

class RoutesCubit extends Cubit<RoutesState> {
  final IRoutesRepository routesRepository;
  final IUserCubit userCubit;
  StreamSubscription? _routeListener;
  StreamSubscription? _userListener;

  RoutesCubit({required this.userCubit, required this.routesRepository})
      : super(RoutesInitial()) {
    _userListener = userCubit.stream.listen((state) {
      state.ifState<UserLoggedIn>(
        withState: (state) => _updateStream(),
        orElse: (state) {},
      );
    });
    // Fire immediately if the user has already logged in
    userCubit.state.ifState<UserLoggedIn>(
      withState: (state) => _updateStream(),
      orElse: (state) {},
    );
  }

  factory RoutesCubit.fromContext(BuildContext context) => RoutesCubit(
        userCubit: context.read<IUserCubit>(),
        routesRepository: context.read<IRoutesRepository>(),
      );

  // Getter for selectedRouteId
  String? get selectedRouteId {
    return state.ifState<RoutesLoaded>(
      withState: (state) => state.route?.id,
      orElse: (state) {}, // Return null when no route is selected
    );
  }

  // Check if any route is selected
  bool hasSelectedRoute() {
    return state.ifState<RoutesLoaded>(
      withState: (state) => state.route != null,
      orElse: (state) {}, // Return false if no route is selected
    );
  }

  void selectRoute(PickupRoute route) {
    state.ifState<RoutesLoaded>(
      withState: (state) {
        final loaded = state.copyWith(route: route);
        emit(loaded);
      },
      orElse: (state) {},
    );
  }

  Future<void> addNewPickup(Pickup pickup) async {
    state.ifState<RoutesLoaded>(
      withState: (state) async {
        final route = state.route;

        if (route == null) {
          print("Route is null, cannot add new pickup.");
          return;
        }

        final docRef =
            FirestoreHelper.instance!.doc(FirestorePath.pickup(pickup.id));

        // Check if the pickup already exists in draftOrders
        bool pickupExists = route.draftOrders.any((ref) => ref.id == pickup.id);

        if (pickupExists) {
          print("Pickup with ID ${pickup.id} already exists in draftOrders.");
          return;
        }

        // Add to draftOrders if it doesn't exist
        final newDraftOrders =
            List<DocumentReference<Object?>>.from(route.draftOrders);
        newDraftOrders.add(docRef);
        final newRoute = route.copyWith(draftOrders: newDraftOrders);

        // Update the route in the repository
        print("Adding new pickup with ID ${pickup.id} to draftOrders.");
        routesRepository.setRoute(newRoute);
      },
      orElse: (state) {},
    );
  }

  Future<void> removeDraftPickupByIds(Iterable<String> ids) async {
    state.ifState<RoutesLoaded>(
      withState: (state) {
        final route = state.route;
        final newDraftOrders = route.draftOrders
            .where((element) => !ids.contains(element.id))
            .toList();
        final newRoute = route.copyWith(draftOrders: newDraftOrders);
        routesRepository.setRoute(newRoute);
      },
      orElse: (state) {},
    );
  }

  // Check if any routes are assigned
  bool hasAnyRoutesAssigned() {
    return state.ifState<RoutesLoaded>(
      withState: (state) => state.routes!.isNotEmpty,
      orElse: (state) => false,
    );
  }

  // Add a new route
  Future<void> addNewRoute(PickupRoute newRoute) async {
    state.ifState<RoutesLoaded>(
      withState: (state) async {
        final updatedRoutes = List<PickupRoute>.from(state.routes!)
          ..add(newRoute);
        final newState = state.copyWith(routes: updatedRoutes);
        emit(newState);
        // await routesRepository
        //     .setRoutes(updatedRoutes); // Update to use setRoutes
      },
      orElse: (state) {},
    );
  }

  // Close a route
  Future<void> closeRoute(String routeId) async {
    state.ifState<RoutesLoaded>(
      withState: (state) async {
        final updatedRoutes = state.routes!.map((route) {
          if (route.id == routeId) {
            return route.copyWith(); // Assuming PickupRoute has isClosed field
          }
          return route;
        }).toList();

        final newState = state.copyWith(routes: updatedRoutes);
        emit(newState);
        // await routesRepository.setRoutes(updatedRoutes);
      },
      orElse: (state) {},
    );
  }

  Future<void> _updateStream() async {
    final userCubitState = userCubit.state;

    await _routeListener?.cancel();
    _routeListener = null;

    if (userCubitState is UserLoggedIn) {
      final stream = routesRepository.getRoutes(userCubitState.driverId);
      emit(RoutesLoading());
      _routeListener = stream.listen((routes) {
        emit(RoutesLoaded(routes: routes, route: routes.first));
      });
    }
  }

  @override
  Future<void> close() async {
    await _userListener?.cancel();
    await _routeListener?.cancel();
    return super.close();
  }
}
