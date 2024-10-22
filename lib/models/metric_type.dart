import 'package:freezed_annotation/freezed_annotation.dart';

part 'metric_type.freezed.dart';

@freezed
abstract class MetricType implements _$MetricType {
  MetricType._();

  factory MetricType({
    final int id,
    final int metric,
    final bool isActive,
  }) = _MetricType;

  factory MetricType.fromMap(Map<String, dynamic> data) {
    return MetricType(
      id: data['id'],
      metric: data['metric'],
      isActive: data['isActive'] ?? true,
    );
  }
}
