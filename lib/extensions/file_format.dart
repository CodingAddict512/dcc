import 'package:dcc/models/file_format.dart';
import 'package:flutter/foundation.dart';

extension StatusExtension on FileFormat {
  String name() {
    return describeEnum(this);
  }
}
