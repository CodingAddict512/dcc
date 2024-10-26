import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dcc/cubits/routes_cubit.dart';
import 'package:dcc/cubits/states/pickups_state.dart';
import 'package:dcc/cubits/states/routes_state.dart';
import 'package:dcc/cubits/states/user_state.dart';
import 'package:dcc/cubits/user_cubit.dart';
import 'package:dcc/data/repositories/pickup_repository_interface.dart';
import 'package:dcc/models/pickup.dart';
import 'package:dcc/models/status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/file_format.dart';
import '../models/metric_type.dart';

class PickupsCubit extends Cubit<PickupsState> {
  final IPickupRepository pickupRepository;
  final RoutesCubit routesCubit;
  final IUserCubit userCubit;
  StreamSubscription? _listener;

  // Constructor
  PickupsCubit({
    required this.pickupRepository,
    required this.routesCubit,
    required this.userCubit,
  }) : super(PickupsInitial()) {
    // Listen to the RoutesCubit state changes
    routesCubit.stream.listen((state) {
      if (state is RoutesLoaded) {
        print("RoutesLoaded detected, updating pickup stream.");
        updateStream();
      }
    });
  }

  // Factory method to create the cubit from context
  factory PickupsCubit.fromContext(BuildContext context) => PickupsCubit(
        userCubit: context.read<IUserCubit>(),
        pickupRepository: context.read<IPickupRepository>(),
        routesCubit: context.read<RoutesCubit>(),
      );

  // Update the pickup stream based on user and routes state
  void updateStream() async {
    print("updateStream called in PickupsCubit");

    final routesCubitState = routesCubit.state;
    final userCubitState = userCubit.state;

    // Cancel previous listener
    await _listener?.cancel();
    _listener = null;

    if (userCubitState is UserLoggedIn && routesCubitState is RoutesLoaded) {
      print("User is logged in and routes are loaded.");
      emit(PickupsLoading());

      try {
        // Fetch pickups from the repository
        final pickups = await pickupRepository.getPickups();
        print("Fetched pickups: $pickups"); // Debug output

        // Emit the loaded state with the pickups
        emit(PickupsLoaded(pickups: pickups, pickup: pickups.first));
      } catch (error) {
        // Emit error state if fetching fails
        emit(PickupsError("Error loading pickups: ${error.toString()}"));
      }
    } else {
      print("User is not logged in or routes are not loaded.");
      emit(PickupsError("User not logged in or routes not loaded."));
    }
  }

  Future<void> savePickup(Pickup newPickup) async {
    await _setNewPickup(newPickup);
  }

  Future<void> deleteDraftPickup(Pickup pickup) async {
    if (pickup.status != Status.DRAFT) return;

    state.ifState<PickupsLoaded>(
      withState: (state) async {
        await pickupRepository.deletePickup(pickup);
        // Call RoutesCubit to remove draft pickup
        await routesCubit.removeDraftPickupByIds([pickup.id]);
      },
      orElse: (state) {},
    );
  }

  Future<void> _setNewPickup(Pickup newPickup) async {
    final userCubitState = userCubit.state;
    final routesCubitState = routesCubit.state;

    if (userCubitState is UserLoggedIn && routesCubitState is RoutesLoaded) {
      state.ifState<PickupsLoaded>(
        withState: (state) async {
          await pickupRepository.setPickup(newPickup);

          if (newPickup.originalStatus == Status.DRAFT) {
            await routesCubit.addNewPickup(newPickup);
          }

          selectPickup(newPickup);
        },
        orElse: (state) {},
      );
    }
  }

  void selectPickup(Pickup pickup) {
    state.ifState<PickupsLoaded>(
      withState: (state) {
        emit(state.copyWith(pickup: pickup));
      },
      orElse: (state) {},
    );
  }

  void registerWeight(
      int newAmount, MetricType newMetric, String weight) async {
    state.ifState<PickupsLoaded>(
      withState: (state) async {
        final newPickup = state.pickup.copyWith(
          actualAmount: newAmount,
          actualMetric: newMetric.metric,
          actualMetricTypeId: newMetric.id,
          actualRegisteredWeight: weight,
        );
        await _setNewPickup(newPickup);
      },
      orElse: (state) {},
    );
  }

  void startPickup() async {
    state.ifState<PickupsLoaded>(
      withState: (state) async {
        String newOrderId = state.pickup.status == Status.DRAFT
            ? "PENDING"
            : state.pickup.orderId;
        final newPickup =
            state.pickup.copyWith(orderId: newOrderId, status: Status.STARTED);
        await _setNewPickup(newPickup);
      },
      orElse: (state) {},
    );
  }

  void finishPickup() async {
    state.ifState<PickupsLoaded>(
      withState: (state) async {
        final pickup = state.pickup;
        final collectedTime = pickup.collectedTime ?? Timestamp.now();
        final newPickup = pickup.copyWith(
          status: Status.SUBMITTED,
          collectedTime: collectedTime,
          actualAmount: pickup.actualAmount ?? pickup.amount,
          actualMetric: pickup.actualMetric ?? pickup.metric,
          actualMetricTypeId: pickup.actualMetricTypeId ?? pickup.metricTypeId,
          actualRegisteredWeight: pickup.actualRegisteredWeight,
          actualFinalDisposition:
              pickup.actualFinalDisposition ?? pickup.finalDisposition,
          actualFinalDispositionId:
              pickup.actualFinalDispositionId ?? pickup.finalDispositionId,
        );
        await _setNewPickup(newPickup);
      },
      orElse: (state) {},
    );
  }

  void editNote(String note) async {
    state.ifState<PickupsLoaded>(
      withState: (state) async {
        final newPickup = state.pickup.copyWith(note: note);
        await _setNewPickup(newPickup);
      },
      orElse: (state) {},
    );
  }

  void registerNhDocFormat(FileFormat format) async {
    state.ifState<PickupsLoaded>(
      withState: (state) async {
        final newPickup = state.pickup.copyWith(
          externalNHDocFormat: format,
        );
        await _setNewPickup(newPickup);
      },
      orElse: (state) {},
    );
  }

  bool hasSelectedRoute() {
    // Check if any route is selected
    return routesCubit.state is RoutesLoaded &&
        routesCubit.selectedRouteId != null;
  }

  Future<void> addNewRoute(/* Parameters for new route */) async {
    // Implement logic to add a new route
  }

  Future<void> closeRoute(/* Parameters for closing the route */) async {
    // Implement logic to close the route
  }

  @override
  Future<void> close() async {
    await _listener?.cancel();
    print("PickupsCubit closed and listener cancelled.");
    return super.close();
  }
}
