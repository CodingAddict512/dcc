import 'dart:async';

import 'package:dcc/cubits/final_disposition_cubit.dart';
import 'package:dcc/cubits/metric_type_cubit.dart';
import 'package:dcc/cubits/pickups_cubit.dart';
import 'package:dcc/cubits/states/pickup_edit_state.dart';
import 'package:dcc/cubits/states/pickups_state.dart';
import 'package:dcc/models/customer.dart';
import 'package:dcc/models/final_disposition.dart';
import 'package:dcc/models/location.dart';
import 'package:dcc/models/metric_type.dart';
import 'package:dcc/models/pickup.dart';
import 'package:dcc/models/status.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PickupEditCubit extends Cubit<PickupEditState> {
  final MetricTypeCubit metricTypeCubit;
  final FinalDispositionCubit finalDispositionCubit;
  final PickupsCubit pickupsCubit;
  StreamSubscription? _listener;

  PickupEditCubit({
    required this.metricTypeCubit,
    required this.finalDispositionCubit,
    required this.pickupsCubit,
  }) : super(PickupEditInitial()) {
    _setupPickupListener();
  }

  factory PickupEditCubit.fromContext(BuildContext context) => PickupEditCubit(
        metricTypeCubit: context.read<MetricTypeCubit>(),
        finalDispositionCubit: context.read<FinalDispositionCubit>(),
        pickupsCubit: context.read<PickupsCubit>(),
      );

  void _setupPickupListener() {
    _listener!.cancel();
    _listener = pickupsCubit.stream.listen((newPickupState) {
      final currentState =
          state is PickupEditLoaded ? state as PickupEditLoaded : null;
      final currentPickup = currentState?.oldPickup;
      if (currentPickup == null) {
        return;
      }
      newPickupState.ifState<PickupsLoaded>(
        withState: (s) {
          final selectedPickup = s.pickup;
          if (selectedPickup.id != currentPickup.id) {
            return;
          }
          final newState = currentState!.copyWith(oldPickup: selectedPickup);
          emit(newState);
        },
        orElse: (state) {},
      );
    });
  }

  void load(Pickup pickup) {
    emit(PickupEditLoading());
    final loaded = PickupEditLoaded.fromPickup(
      pickup,
      metricTypeCubit,
      finalDispositionCubit,
    );
    emit(loaded);
  }

  Pickup editedPickup(PickupEditLoaded state) {
    if (state.oldPickup.status == Status.DRAFT) {
      /* Newly created one that we have not started yet.
       * Here we update the amount and metric field directly.
       */
      return state.oldPickup.copyWith(
        finalDispositionId: state.actualFinalDisposition?.id,
        finalDisposition: state.actualFinalDisposition?.type,
        amount: state.actualAmount,
        metric: state.actualMetric?.metric,
        metricTypeId: state.actualMetric?.id,
        actualAmount: state.actualAmount,
        actualMetric: state.actualMetric?.metric,
        actualMetricTypeId: state.actualMetric?.id,
        actualFinalDisposition: state.actualFinalDisposition?.type,
        actualFinalDispositionId: state.actualFinalDisposition?.id,
        actualRegisteredWeight: state.weight,
        originCustomer: state.originCustomer,
        originLocation: state.originLocation,
        receiverCustomer: state.receiverCustomer,
        receiverLocation: state.receiverLocation,
        description: state.description,
        note: state.note,
      );
    }
    /* Here we only update actualAmount and actualMetrics */
    return state.oldPickup.copyWith(
      actualFinalDispositionId: state.actualFinalDisposition?.id,
      actualFinalDisposition: state.actualFinalDisposition?.type,
      actualRegisteredWeight: state.weight,
      actualAmount: state.actualAmount,
      actualMetric: state.actualMetric?.metric,
      actualMetricTypeId: state.actualMetric?.id,
      originCustomer: state.originCustomer,
      originLocation: state.originLocation,
      receiverCustomer: state.receiverCustomer,
      receiverLocation: state.receiverLocation,
      description: state.description,
      note: state.note,
    );
  }

  Future<void> save() async {
    state.ifState<PickupEditLoaded>(
      withState: (state) {
        final newPickup = editedPickup(state);
        return pickupsCubit.savePickup(newPickup);
      },
      orElse: (state) {},
    );
  }

  void registerWeight(
    int newAmount,
    MetricType newMetric,
    String weight,
  ) async {
    state.ifState<PickupEditLoaded>(
      withState: (state) async {
        final loaded = state.copyWith(
          actualAmount: newAmount,
          actualMetric: newMetric,
          weight: weight,
        );
        emit(loaded);
      },
      orElse: (state) {},
    );
  }

  void newNote(String note) {
    state.ifState<PickupEditLoaded>(
      withState: (state) {
        final loaded = state.copyWith(note: note);
        emit(loaded);
      },
      orElse: (state) {},
    );
  }

  void selectFinalDispositionType(FinalDisposition actualFinalDisposition) {
    state.ifState<PickupEditLoaded>(
      withState: (state) async {
        final loaded = state.copyWith(
          actualFinalDisposition: actualFinalDisposition,
        );
        emit(loaded);
      },
      orElse: (state) {},
    );
  }

  void selectOriginCustomer(Customer customer) {
    state.ifState<PickupEditLoaded>(
      withState: (state) async {
        final loaded = state.copyWith(
          originCustomer: customer,
          originLocation: customer.primaryLocation,
        );
        emit(loaded);
      },
      orElse: (state) {},
    );
  }

  void selectOriginLocation(Location location) {
    state.ifState<PickupEditLoaded>(
      withState: (state) {
        final loaded = state.copyWith(originLocation: location);
        emit(loaded);
      },
      orElse: (state) {},
    );
  }

  void selectReceiverCustomer(Customer customer) {
    state.ifState<PickupEditLoaded>(
      withState: (state) async {
        final loaded = state.copyWith(
          receiverCustomer: customer,
          receiverLocation: customer.primaryLocation,
        );
        emit(loaded);
      },
      orElse: (state) {},
    );
  }

  void selectReceiverLocation(Location location) {
    state.ifState<PickupEditLoaded>(
      withState: (state) {
        final loaded = state.copyWith(receiverLocation: location);
        emit(loaded);
      },
      orElse: (state) {},
    );
  }

  @override
  Future<void> close() async {
    await _listener!.cancel();
    return super.close();
  }
}
