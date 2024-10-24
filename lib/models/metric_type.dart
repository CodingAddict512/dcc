// import 'package:freezed_annotation/freezed_annotation.dart';

// part 'metric_type.freezed.dart';

// @freezed
// abstract class MetricType implements _$MetricType {
//   MetricType._();

//   factory MetricType({
//     final int id,
//     final int metric,
//     final bool isActive,
//   }) = _MetricType;

//   factory MetricType.fromMap(Map<String, dynamic> data) {
//     return MetricType(
//       id: data['id'],
//       metric: data['metric'],
//       isActive: data['isActive'] ?? true,
//     );
//   }
// }

class MetricType {
  final int? id;
  final int? metric;
  final bool isActive;

  // Constructor with default values and null safety
  MetricType({
    required this.id,
    required this.metric,
    this.isActive = true,
  });

  // Named constructor for creating an instance from a Map
  factory MetricType.fromMap(Map<String, dynamic> data) {
    return MetricType(
      id: data['id'] as int?,
      metric: data['metric'] as int?,
      isActive: data['isActive'] as bool? ?? true,
    );
  }

  // Method to convert the object back to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'metric': metric,
      'isActive': isActive,
    };
  }
}
