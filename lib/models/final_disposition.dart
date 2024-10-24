// import 'package:dcc/extensions/nh_category.dart';
// import 'package:dcc/models/nh_category.dart';
// import 'package:freezed_annotation/freezed_annotation.dart';

// part 'final_disposition.freezed.dart';

// @freezed
// abstract class FinalDisposition with _$FinalDisposition {
//   FinalDisposition._();

//   factory FinalDisposition({
//     final int id,
//     final String type,
//     final bool outgoingDispositionType,
//     final NHCategory category,
//     final bool isActive,
//   }) = _FinalDisposition;

//   factory FinalDisposition.fromMap(Map<String, dynamic> data) {
//     return FinalDisposition(
//       id: data['id'],
//       type: data["type"],
//       outgoingDispositionType: data["outgoingDispositionType"] ?? false,
//       category: NHCategory.values.firstWhere((e) => e.name() == data["category"]),
//       isActive: data['isActive'] ?? true,
//     );
//   }
// }

import 'package:dcc/extensions/nh_category.dart';
import 'package:dcc/models/nh_category.dart';

class FinalDisposition {
  final int id;
  final String type;
  final bool outgoingDispositionType;
  final NHCategory category;
  final bool isActive;

  FinalDisposition({
    required this.id,
    required this.type,
    required this.outgoingDispositionType,
    required this.category,
    required this.isActive,
  });

  factory FinalDisposition.fromMap(Map<String, dynamic> data) {
    return FinalDisposition(
      id: data['id'] as int,
      type: data["type"] as String,
      outgoingDispositionType: data["outgoingDispositionType"] ?? false,
      category: NHCategory.values.firstWhere(
          (e) => e.name() == data["category"],
          orElse: () =>
              NHCategory.KATEGORI1), // Replace with appropriate default
      isActive: data['isActive'] ?? true,
    );
  }
}
