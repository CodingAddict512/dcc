import 'package:dcc/cubits/states/base_state.dart';
import 'package:dcc/models/metric_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta/meta.dart';

part 'metric_type_state.freezed.dart';

@immutable
abstract class MetricTypeState extends BaseState {
  const MetricTypeState();
}

@freezed
abstract class MetricTypeStateInitial extends MetricTypeState with _$MetricTypeStateInitial {
  MetricTypeStateInitial._();

  factory MetricTypeStateInitial() = _MetricTypeStateInitial;
}

@freezed
abstract class MetricTypeStateLoading extends MetricTypeState with _$MetricTypeStateLoading {
  MetricTypeStateLoading._();

  factory MetricTypeStateLoading() = _MetricTypeStateLoading;
}

@freezed
abstract class MetricTypeStateNoMetrics extends MetricTypeState with _$MetricTypeStateNoMetrics {
  MetricTypeStateNoMetrics._();

  factory MetricTypeStateNoMetrics() = _MetricTypeStateNoMetrics;
}

@freezed
abstract class MetricTypeStateLoaded extends MetricTypeState with _$MetricTypeStateLoaded {
  MetricTypeStateLoaded._();

  factory MetricTypeStateLoaded({
    final List<MetricType> metricTypes,
  }) = _MetricTypeStateLoaded;

  List<MetricType> getActiveMetricTypes() => metricTypes
      .where((element) => element.isActive)
      .toList(growable: false);
}

@freezed
abstract class MetricTypeStateError extends MetricTypeState with _$MetricTypeStateError {
  MetricTypeStateError._();

  factory MetricTypeStateError({
    final String message,
  }) = _MetricTypeStateError;
}
