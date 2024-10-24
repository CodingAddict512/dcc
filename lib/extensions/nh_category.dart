import 'package:dcc/models/nh_category.dart';
import 'package:flutter/foundation.dart';

extension NHCategoryExtension on NHCategory {
  String name() {
    return describeEnum(this);
  }
}
