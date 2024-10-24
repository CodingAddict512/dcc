// import 'package:dcc/cubits/states/base_state.dart';
// import 'package:dcc/models/metric_type.dart';
// import 'package:freezed_annotation/freezed_annotation.dart';

// part 'metric_type_state.freezed.dart';

// @immutable
// abstract class MetricTypeState extends BaseState {
//   const MetricTypeState();
// }

// @freezed
// abstract class MetricTypeStateInitial extends MetricTypeState with _$MetricTypeStateInitial {
//   MetricTypeStateInitial._();

//   factory MetricTypeStateInitial() = _MetricTypeStateInitial;
// }

// @freezed
// abstract class MetricTypeStateLoading extends MetricTypeState with _$MetricTypeStateLoading {
//   MetricTypeStateLoading._();

//   factory MetricTypeStateLoading() = _MetricTypeStateLoading;
// }

// @freezed
// abstract class MetricTypeStateNoMetrics extends MetricTypeState with _$MetricTypeStateNoMetrics {
//   MetricTypeStateNoMetrics._();

//   factory MetricTypeStateNoMetrics() = _MetricTypeStateNoMetrics;
// }

// @freezed
// abstract class MetricTypeStateLoaded extends MetricTypeState with _$MetricTypeStateLoaded {
//   MetricTypeStateLoaded._();

//   factory MetricTypeStateLoaded({
//     final List<MetricType> metricTypes,
//   }) = _MetricTypeStateLoaded;

//   List<MetricType> getActiveMetricTypes() => metricTypes
//       .where((element) => element.isActive)
//       .toList(growable: false);
// }

// @freezed
// abstract class MetricTypeStateError extends MetricTypeState with _$MetricTypeStateError {
//   MetricTypeStateError._();

//   factory MetricTypeStateError({
//     final String message,
//   }) = _MetricTypeStateError;
// }



import 'package:dcc/cubits/states/base_state.dart';
import 'package:dcc/models/metric_type.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class MetricTypeState extends BaseState {
  const MetricTypeState();
}

class MetricTypeStateInitial extends MetricTypeState {
  const MetricTypeStateInitial();
}

class MetricTypeStateLoading extends MetricTypeState {
  const MetricTypeStateLoading();
}

class MetricTypeStateNoMetrics extends MetricTypeState {
  const MetricTypeStateNoMetrics();
}

class MetricTypeStateLoaded extends MetricTypeState {
  final List<MetricType> metricTypes;

  const MetricTypeStateLoaded({
    required this.metricTypes,
  });

  List<MetricType> getActiveMetricTypes() {
    return metricTypes.where((element) => element.isActive).toList(growable: false);
  }

  MetricTypeStateLoaded copyWith({
    List<MetricType>? metricTypes,
  }) {
    return MetricTypeStateLoaded(
      metricTypes: metricTypes ?? this.metricTypes,
    );
  }
}

class MetricTypeStateError extends MetricTypeState {
  final String message;

  const MetricTypeStateError({
    required this.message,
  });

  MetricTypeStateError copyWith({
    String? message,
  }) {
    return MetricTypeStateError(
      message: message ?? this.message,
    );
  }
}
