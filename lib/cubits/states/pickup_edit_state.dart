// import 'package:dcc/cubits/metric_type_cubit.dart';
// import 'package:dcc/cubits/states/base_state.dart';
// import 'package:dcc/models/customer.dart';
// import 'package:dcc/models/file_format.dart';
// import 'package:dcc/models/final_disposition.dart';
// import 'package:dcc/models/location.dart';
// import 'package:dcc/models/metric_type.dart';
// import 'package:dcc/models/pickup.dart';
// import 'package:freezed_annotation/freezed_annotation.dart';

// import '../final_disposition_cubit.dart';

// part 'pickup_edit_state.freezed.dart';

// @immutable
// abstract class PickupEditState extends BaseState {
//   const PickupEditState();
// }

// @freezed
// abstract class PickupEditInitial extends PickupEditState with _$PickupEditInitial {
//   PickupEditInitial._();

//   factory PickupEditInitial() = _PickupEditInitial;
// }

// @freezed
// abstract class PickupEditLoading extends PickupEditState with _$PickupEditLoading {
//   PickupEditLoading._();

//   factory PickupEditLoading() = _PickupEditLoading;
// }

// @freezed
// abstract class PickupEditLoaded extends PickupEditState with _$PickupEditLoaded {
//   PickupEditLoaded._();

//   factory PickupEditLoaded({
//     final FinalDisposition finalDisposition,
//     final FinalDisposition actualFinalDisposition,
//     final int amount,
//     final MetricType metric,
//     final int actualAmount,
//     final MetricType actualMetric,
//     final String weight,
//     final Customer originCustomer,
//     final Location originLocation,
//     final Customer receiverCustomer,
//     final Location receiverLocation,
//     final String description,
//     final String note,
//     final Pickup oldPickup,
//     final FileFormat externalNHDocFormat,
//   }) = _PickupEditLoaded;

//   static PickupEditLoaded fromPickup(
//     Pickup pickup,
//     MetricTypeCubit metricTypeCubit,
//     FinalDispositionCubit finalDispositionCubit,
//   ) {
//     return PickupEditLoaded(
//       actualFinalDisposition:
//           pickup.actualFinalDispositionId == null ? null : finalDispositionCubit.finalDispositionFromId(pickup.actualFinalDispositionId),
//       finalDisposition: pickup.finalDisposition == null ? null : finalDispositionCubit.finalDispositionFromId(pickup.finalDispositionId),
//       amount: pickup.amount,
//       metric: pickup.metricTypeId == null ? null : metricTypeCubit.metricTypeFromId(pickup.metricTypeId),
//       actualAmount: pickup.actualAmount,
//       actualMetric: pickup.actualMetricTypeId == null ? null : metricTypeCubit.metricTypeFromId(pickup.actualMetricTypeId),
//       weight: pickup.actualRegisteredWeight,
//       originCustomer: pickup.originCustomer,
//       originLocation: pickup.originLocation,
//       receiverCustomer: pickup.receiverCustomer,
//       receiverLocation: pickup.receiverLocation,
//       description: pickup.description,
//       note: pickup.note,
//       externalNHDocFormat: pickup.externalNHDocFormat,
//       oldPickup: pickup,
//     );
//   }
// }

// @freezed
// abstract class PickupEditError extends PickupEditState with _$PickupEditError {
//   PickupEditError._();

//   factory PickupEditError({
//     final String message,
//   }) = _PickupEditError;
// }

// import 'package:dcc/cubits/metric_type_cubit.dart';
// import 'package:dcc/cubits/states/base_state.dart';
// import 'package:dcc/models/customer.dart';
// import 'package:dcc/models/file_format.dart';
// import 'package:dcc/models/final_disposition.dart';
// import 'package:dcc/models/location.dart';
// import 'package:dcc/models/metric_type.dart';
// import 'package:dcc/models/pickup.dart';
// import '../final_disposition_cubit.dart';

// class PickupEditState extends BaseState {
//   const PickupEditState();
// }

// class PickupEditInitial extends PickupEditState {
//   const PickupEditInitial();
// }

// class PickupEditLoading extends PickupEditState {
//   const PickupEditLoading();
// }

// class PickupEditLoaded extends PickupEditState {
//   final FinalDisposition? finalDisposition;
//   final FinalDisposition? actualFinalDisposition;
//   final int amount;
//   final MetricType? metric;
//   final int actualAmount;
//   final MetricType? actualMetric;
//   final String weight;
//   final Customer originCustomer;
//   final Location originLocation;
//   final Customer receiverCustomer;
//   final Location receiverLocation;
//   final String description;
//   final String note;
//   final Pickup oldPickup;
//   final FileFormat? externalNHDocFormat;

//   const PickupEditLoaded({
//     required this.finalDisposition,
//     required this.actualFinalDisposition,
//     required this.amount,
//     required this.metric,
//     required this.actualAmount,
//     required this.actualMetric,
//     required this.weight,
//     required this.originCustomer,
//     required this.originLocation,
//     required this.receiverCustomer,
//     required this.receiverLocation,
//     required this.description,
//     required this.note,
//     required this.oldPickup,
//     required this.externalNHDocFormat,
//   });

//   static PickupEditLoaded fromPickup(
//     Pickup pickup,
//     MetricTypeCubit metricTypeCubit,
//     FinalDispositionCubit finalDispositionCubit,
//   ) {
//     return PickupEditLoaded(
//       actualFinalDisposition: pickup.actualFinalDispositionId == null
//           ? null
//           : finalDispositionCubit
//               .finalDispositionFromId(pickup.actualFinalDispositionId!),
//       finalDisposition: pickup.finalDispositionId == null
//           ? null
//           : finalDispositionCubit
//               .finalDispositionFromId(pickup.finalDispositionId!),
//       amount: pickup.amount!,
//       metric: pickup.metricTypeId == null
//           ? null
//           : metricTypeCubit.metricTypeFromId(pickup.metricTypeId!),
//       actualAmount: pickup.actualAmount!,
//       actualMetric: pickup.actualMetricTypeId == null
//           ? null
//           : metricTypeCubit.metricTypeFromId(pickup.actualMetricTypeId!),
//       weight: pickup.actualRegisteredWeight!,
//       originCustomer: pickup.originCustomer!,
//       originLocation: pickup.originLocation!,
//       receiverCustomer: pickup.receiverCustomer!,
//       receiverLocation: pickup.receiverLocation!,
//       description: pickup.description!,
//       note: pickup.note!,
//       externalNHDocFormat: pickup.externalNHDocFormat,
//       oldPickup: pickup,
//     );
//   }
// }

// class PickupEditError extends PickupEditState {
//   final String message;

//   const PickupEditError(this.message);
// }

import 'package:dcc/cubits/metric_type_cubit.dart';
import 'package:dcc/cubits/states/base_state.dart';
import 'package:dcc/models/customer.dart';
import 'package:dcc/models/file_format.dart';
import 'package:dcc/models/final_disposition.dart';
import 'package:dcc/models/location.dart';
import 'package:dcc/models/metric_type.dart';
import 'package:dcc/models/pickup.dart';
import '../final_disposition_cubit.dart';

class PickupEditState extends BaseState {
  const PickupEditState();
}

class PickupEditInitial extends PickupEditState {
  const PickupEditInitial();
}

class PickupEditLoading extends PickupEditState {
  const PickupEditLoading();
}

class PickupEditLoaded extends PickupEditState {
  final FinalDisposition? finalDisposition;
  final FinalDisposition? actualFinalDisposition;
  final int amount;
  final MetricType? metric;
  final int actualAmount;
  final MetricType? actualMetric;
  final String weight;
  final Customer originCustomer;
  final Location originLocation;
  final Customer receiverCustomer;
  final Location receiverLocation;
  final String description;
  final String note;
  final Pickup oldPickup;
  final FileFormat? externalNHDocFormat;

  const PickupEditLoaded({
    required this.finalDisposition,
    required this.actualFinalDisposition,
    required this.amount,
    required this.metric,
    required this.actualAmount,
    required this.actualMetric,
    required this.weight,
    required this.originCustomer,
    required this.originLocation,
    required this.receiverCustomer,
    required this.receiverLocation,
    required this.description,
    required this.note,
    required this.oldPickup,
    required this.externalNHDocFormat,
  });

  PickupEditLoaded copyWith({
    FinalDisposition? finalDisposition,
    FinalDisposition? actualFinalDisposition,
    int? amount,
    MetricType? metric,
    int? actualAmount,
    MetricType? actualMetric,
    String? weight,
    Customer? originCustomer,
    Location? originLocation,
    Customer? receiverCustomer,
    Location? receiverLocation,
    String? description,
    String? note,
    Pickup? oldPickup,
    FileFormat? externalNHDocFormat,
  }) {
    return PickupEditLoaded(
      finalDisposition: finalDisposition ?? this.finalDisposition,
      actualFinalDisposition:
          actualFinalDisposition ?? this.actualFinalDisposition,
      amount: amount ?? this.amount,
      metric: metric ?? this.metric,
      actualAmount: actualAmount ?? this.actualAmount,
      actualMetric: actualMetric ?? this.actualMetric,
      weight: weight ?? this.weight,
      originCustomer: originCustomer ?? this.originCustomer,
      originLocation: originLocation ?? this.originLocation,
      receiverCustomer: receiverCustomer ?? this.receiverCustomer,
      receiverLocation: receiverLocation ?? this.receiverLocation,
      description: description ?? this.description,
      note: note ?? this.note,
      oldPickup: oldPickup ?? this.oldPickup,
      externalNHDocFormat: externalNHDocFormat ?? this.externalNHDocFormat,
    );
  }

  static PickupEditLoaded fromPickup(
    Pickup pickup,
    MetricTypeCubit metricTypeCubit,
    FinalDispositionCubit finalDispositionCubit,
  ) {
    return PickupEditLoaded(
      actualFinalDisposition: pickup.actualFinalDispositionId == null
          ? null
          : finalDispositionCubit
              .finalDispositionFromId(pickup.actualFinalDispositionId!),
      finalDisposition: pickup.finalDispositionId == null
          ? null
          : finalDispositionCubit
              .finalDispositionFromId(pickup.finalDispositionId!),
      amount: pickup.amount!,
      metric: pickup.metricTypeId == null
          ? null
          : metricTypeCubit.metricTypeFromId(pickup.metricTypeId!),
      actualAmount: pickup.actualAmount!,
      actualMetric: pickup.actualMetricTypeId == null
          ? null
          : metricTypeCubit.metricTypeFromId(pickup.actualMetricTypeId!),
      weight: pickup.actualRegisteredWeight!,
      originCustomer: pickup.originCustomer!,
      originLocation: pickup.originLocation!,
      receiverCustomer: pickup.receiverCustomer!,
      receiverLocation: pickup.receiverLocation!,
      description: pickup.description!,
      note: pickup.note!,
      externalNHDocFormat: pickup.externalNHDocFormat,
      oldPickup: pickup,
    );
  }
}

class PickupEditError extends PickupEditState {
  final String message;

  const PickupEditError(this.message);
}
