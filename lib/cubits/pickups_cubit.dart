import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dcc/cubits/routes_cubit.dart';
import 'package:dcc/cubits/states/pickups_state.dart';
import 'package:dcc/cubits/states/routes_state.dart';
import 'package:dcc/cubits/states/user_state.dart';
import 'package:dcc/cubits/user_cubit.dart';
import 'package:dcc/data/repositories/pickup_repository_interface.dart';
import 'package:dcc/models/file_format.dart';
import 'package:dcc/models/metric_type.dart';
import 'package:dcc/models/pickup.dart';
import 'package:dcc/models/pickup_with_references.dart';
import 'package:dcc/models/status.dart';
// import 'package:device_info/device_info.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PickupsCubit extends Cubit<PickupsState> {
  final IPickupRepository pickupRepository;
  final RoutesCubit routesCubit;
  final IUserCubit userCubit;
  StreamSubscription? _listener;

  PickupsCubit({
    required this.pickupRepository,
    required this.routesCubit,
    required this.userCubit,
  }) : super(PickupsInitial()) {
    routesCubit.stream.listen((state) {
      state.ifState<RoutesLoaded>(
        withState: (state) {
          updateStream();
        },
        orElse: (state) {},
      );
    });
  }

  factory PickupsCubit.fromContext(BuildContext context) => PickupsCubit(
        userCubit: context.read<IUserCubit>(),
        pickupRepository: context.read<IPickupRepository>(),
        routesCubit: context.read<RoutesCubit>(),
      );

  void updateStream() async {
    final routesCubitState = routesCubit.state;
    final userCubitState = userCubit.state;

    /* If we were listening on a stream stop it now */
    await _listener!.cancel();
    _listener = null;

    if (userCubitState is UserLoggedIn && routesCubitState is RoutesLoaded) {
      Pickup oldPickup = state.ifState<PickupsLoaded>(
        withState: (state) => state.pickup,
        orElse: (state) => null,
      );
      emit(PickupsLoading());

      Stream<List<PickupWithReferences>> pickupsStream =
          pickupRepository.getPickupsWithRefs(
        userCubitState.driverId,
        routesCubitState.route.id,
      );

      final stream = pickupsStream.asyncMap((pickups) {
        return Future.wait(
          pickups.map((p) => Pickup.fromPickupWithReferences(p)),
        );
      });
      _listener = stream.listen((pickups) {
        final allActiveIds = pickups.map((event) => event.id).toSet();
        List<DocumentReference> draftOrders =
            routesCubitState.route?.draftOrders ?? [];
        final absentIds = draftOrders
            .where((element) => !allActiveIds.contains(element.id))
            .map((e) => e.id)
            .toList();

        if (absentIds.isNotEmpty) {
          routesCubit.removeDraftPickupByIds(absentIds);
        }

        state.ifState<PickupsLoaded>(
          withState: (state) {
            final newSelectedPickup = pickups.firstWhere(
              (element) => element.id == state.pickup.id,
            );

            emit(state.copyWith(pickups: pickups, pickup: newSelectedPickup));
          },
          orElse: (state) {},
        );
        state.ifState<PickupsLoading>(
          withState: (state) {
            Pickup selectedPickup = oldPickup;
            if (selectedPickup == null && pickups.isNotEmpty) {
              selectedPickup = pickups.first;
            }
            final loaded = PickupsLoaded(
              pickup: selectedPickup,
              pickups: pickups,
            );
            emit(loaded);
          },
          orElse: (state) {},
        );
      });
    }
  }

  void selectPickup(Pickup pickup) {
    state.ifState<PickupsLoaded>(
      withState: (state) async {
        final loaded = state.copyWith(pickup: pickup);
        emit(loaded);
      },
      orElse: (state) {},
    );
  }

  void startPickup() async {
    state.ifState<PickupsLoaded>(
      withState: (state) async {
        // When going from DRAFT to non-DRAFT then we set the ID to "PENDING".
        // This informs the backend that it should allocate an ID for the order.
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

  void resetPickup() async {
    state.ifState<PickupsLoaded>(
      withState: (state) async {
        final newPickup = state.pickup.copyWith(status: Status.ASSIGNED);
        await _setNewPickup(newPickup);
      },
      orElse: (state) {},
    );
  }

  // Future<String> _getDeviceID() async {
  //   DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  //   String id = null;
  //   if (Platform.isAndroid) {
  //     AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
  //     id = androidDeviceInfo.androidId;
  //   } else if (Platform.isIOS) {
  //     IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
  //     id = iosDeviceInfo.identifierForVendor;
  //   }
  //   return id;
  // }

  Future<void> deleteDraftPickup() async {
    state.ifState<PickupsLoaded>(
      withState: (state) async {
        final pickup = state.pickup;
        if (pickup.status != Status.DRAFT) {
          return;
        }
        _deletePickup(pickup);
      },
      orElse: (state) {},
    );
  }

  void finishPickup() async {
    state.ifState<PickupsLoaded>(
      withState: (state) async {
        final pickup = state.pickup;
        final collectedTime = pickup.collectedTime ?? Timestamp.now();
        // String deviceId = await _getDeviceID();
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
          // deviceId: deviceId,
        );
        await _setNewPickup(newPickup);
      },
      orElse: (state) {},
    );
  }

  void registerWeight(
    int newAmount,
    MetricType newMetric,
    String weight,
  ) async {
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

  void editNote(String note) async {
    state.ifState<PickupsLoaded>(
      withState: (state) async {
        final newPickup = state.pickup.copyWith(note: note);
        await _setNewPickup(newPickup);
      },
      orElse: (state) {},
    );
  }

  Future<void> savePickup(Pickup newPickup) async {
    await _setNewPickup(newPickup);
  }

  Future<void> _deletePickup(Pickup pickup) async {
    state.ifState<PickupsLoaded>(
      withState: (state) async {
        await pickupRepository.deletePickup(pickup);
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
        // withState: (state) async {
        //   await pickupRepository.setPickup(newPickup);
        //   if (newPickup.originalStatus == Status.DRAFT) {
        //     await routesCubit.addNewPickup(newPickup);
        //   }
        //   final updatedPickup = newPickup.copyWith(
        //     originalStatus: newPickup.status,
        //   );
        //   await selectPickup(updatedPickup);
        // },
        withState: (state) async {
          await pickupRepository.setPickup(newPickup);

          if (newPickup.originalStatus == Status.DRAFT) {
            await routesCubit.addNewPickup(newPickup);
          }

          // Update the pickup status
          final updatedPickup = newPickup.copyWith(
            originalStatus: newPickup.status,
          );

          // Call selectPickup without awaiting or assigning the result
          selectPickup(updatedPickup);
        },

        orElse: (state) {},
      );
    }
  }

  @override
  Future<void> close() async {
    await _listener!.cancel();
    return super.close();
  }
}
