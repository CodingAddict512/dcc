import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dcc/cubits/states/routes_state.dart';
import 'package:dcc/cubits/states/user_state.dart';
import 'package:dcc/cubits/user_cubit.dart';
import 'package:dcc/data/firestore/firestore_helper.dart';
import 'package:dcc/data/firestore/firestore_path.dart';
import 'package:dcc/data/repositories/routes_repository_interface.dart';
import 'package:dcc/models/pickup.dart';
import 'package:dcc/models/pickup_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class RoutesCubit extends Cubit<RoutesState> {
  final IRoutesRepository routesRepository;
  final IUserCubit userCubit;
  StreamSubscription _routeListener;
  StreamSubscription _userListener;

  RoutesCubit({@required this.userCubit, @required this.routesRepository}) : super(RoutesInitial()) {
    _userListener = userCubit.listen((state) {
      state.ifState<UserLoggedIn>(withState: (state) => _updateStream());
    });
    // Fire immediately if the user has already logged in
    userCubit.state.ifState<UserLoggedIn>(withState: (state) => _updateStream());
  }

  factory RoutesCubit.fromContext(BuildContext context) => RoutesCubit(
        userCubit: context.read<IUserCubit>(),
        routesRepository: context.read<IRoutesRepository>(),
      );

  bool hasAnyRoutesAssigned() => state.ifState<RoutesLoaded>(withState: (s) => s.routes.isNotEmpty, orElse: (s) => false);

  bool hasSelectedRoute() => state.ifState<RoutesLoaded>(withState: (s) => s.route != null, orElse: (s) => false);

  void selectRoute(PickupRoute route) {
    state.ifState<RoutesLoaded>(withState: (state) {
      final loaded = state.copyWith(
        route: route,
      );
      emit(loaded);
    });
  }

  Future<void> closeRoute() async {
    state.ifState<RoutesLoaded>(withState: (state) {
      final newRoute = state.route.copyWith(isActive: false, draftOrders: []);
      routesRepository.setRoute(newRoute);
    });
  }

  Future<void> removeDraftPickupByIds(Iterable<String> ids) {
    return state.ifState<RoutesLoaded>(withState: (state) {
      final idSet = ids.toSet();
      final route = state.route;
      final newDraftOrders = new List<DocumentReference>.from(route.draftOrders).where((element) => !idSet.contains(element.id)).toList();
      final newRoute = route.copyWith(
        draftOrders: newDraftOrders,
      );
      routesRepository.setRoute(newRoute);
    });
  }

  Future<void> addNewPickup(Pickup pickup) async {
    return state.ifState<RoutesLoaded>(withState: (state) {
      final route = state.route;
      final docRef = FirestoreHelper.instance.doc(FirestorePath.pickup(pickup.id));
      if (route == null || route.allOrders.firstWhere((ref) => ref.id == pickup.id, orElse: () => null) != null) {
        return route;
      }
      final newDraftOrders = new List<DocumentReference>.from(route.draftOrders).toList();
      newDraftOrders.add(docRef);
      final newRoute = route.copyWith(
        draftOrders: newDraftOrders,
      );
      routesRepository.setRoute(newRoute);
    });
  }

  Future<void> addNewRoute(PickupRoute route) async {
    await routesRepository.setRoute(route);

    state.ifState<RoutesLoaded>(withState: (state) {
      /* Select the new route if possible; TODO there is a race condition here
       *
       */
      final selectedRoute = state.routes.firstWhere(
        (element) => element.id == route.id,
        orElse: () => state.route,
      );
      final newState = state.copyWith(route: selectedRoute);
      emit(newState);
    });
  }

  void _updateStream() async {
    final userCubitState = userCubit.state;

    /* If we were listening on a stream stop it now */
    await _routeListener?.cancel();
    _routeListener = null;

    if (userCubitState is UserLoggedIn) {
      final stream = routesRepository.getRoutes(userCubitState.driverId);
      final loading = RoutesLoading();
      emit(loading);
      _routeListener = stream.listen((routes) {
        state.ifState<RoutesLoaded>(
          withState: (state) {
            final selectedRouteId = state.route?.id;
            final newSelectedRoute = routes.firstWhere((r) => r.id == selectedRouteId, orElse: () => routes.isNotEmpty ? routes.first : null);
            emit(state.copyWith(
              route: newSelectedRoute,
              routes: routes,
            ));
          },
        );
        state.ifState<RoutesLoading>(withState: (state) {
          RoutesLoaded loaded = RoutesLoaded(route: routes.isNotEmpty ? routes.first : null, routes: routes);
          emit(loaded);
        });
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
