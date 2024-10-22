import 'package:dcc/cubits/metric_type_cubit.dart';
import 'package:dcc/cubits/states/base_state.dart';
import 'package:dcc/models/customer.dart';
import 'package:dcc/models/file_format.dart';
import 'package:dcc/models/final_disposition.dart';
import 'package:dcc/models/location.dart';
import 'package:dcc/models/metric_type.dart';
import 'package:dcc/models/pickup.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../final_disposition_cubit.dart';

part 'pickup_edit_state.freezed.dart';

@immutable
abstract class PickupEditState extends BaseState {
  const PickupEditState();
}

@freezed
abstract class PickupEditInitial extends PickupEditState with _$PickupEditInitial {
  PickupEditInitial._();

  factory PickupEditInitial() = _PickupEditInitial;
}

@freezed
abstract class PickupEditLoading extends PickupEditState with _$PickupEditLoading {
  PickupEditLoading._();

  factory PickupEditLoading() = _PickupEditLoading;
}

@freezed
abstract class PickupEditLoaded extends PickupEditState with _$PickupEditLoaded {
  PickupEditLoaded._();

  factory PickupEditLoaded({
    final FinalDisposition finalDisposition,
    final FinalDisposition actualFinalDisposition,
    final int amount,
    final MetricType metric,
    final int actualAmount,
    final MetricType actualMetric,
    final String weight,
    final Customer originCustomer,
    final Location originLocation,
    final Customer receiverCustomer,
    final Location receiverLocation,
    final String description,
    final String note,
    final Pickup oldPickup,
    final FileFormat externalNHDocFormat,
  }) = _PickupEditLoaded;

  static PickupEditLoaded fromPickup(
    Pickup pickup,
    MetricTypeCubit metricTypeCubit,
    FinalDispositionCubit finalDispositionCubit,
  ) {
    return PickupEditLoaded(
      actualFinalDisposition:
          pickup.actualFinalDispositionId == null ? null : finalDispositionCubit.finalDispositionFromId(pickup.actualFinalDispositionId),
      finalDisposition: pickup.finalDisposition == null ? null : finalDispositionCubit.finalDispositionFromId(pickup.finalDispositionId),
      amount: pickup.amount,
      metric: pickup.metricTypeId == null ? null : metricTypeCubit.metricTypeFromId(pickup.metricTypeId),
      actualAmount: pickup.actualAmount,
      actualMetric: pickup.actualMetricTypeId == null ? null : metricTypeCubit.metricTypeFromId(pickup.actualMetricTypeId),
      weight: pickup.actualRegisteredWeight,
      originCustomer: pickup.originCustomer,
      originLocation: pickup.originLocation,
      receiverCustomer: pickup.receiverCustomer,
      receiverLocation: pickup.receiverLocation,
      description: pickup.description,
      note: pickup.note,
      externalNHDocFormat: pickup.externalNHDocFormat,
      oldPickup: pickup,
    );
  }
}

@freezed
abstract class PickupEditError extends PickupEditState with _$PickupEditError {
  PickupEditError._();

  factory PickupEditError({
    final String message,
  }) = _PickupEditError;
}
