// import 'package:freezed_annotation/freezed_annotation.dart';
// import 'package:package_info_plus/package_info_plus.dart';

// import 'base_state.dart';

// part 'version_state.freezed.dart';

// @immutable
// abstract class VersionState extends BaseState {
//   const VersionState();
// }

// @freezed
// abstract class VersionNotLoaded extends VersionState with _$VersionNotLoaded {
//   VersionNotLoaded._();

//   factory VersionNotLoaded() = _VersionNotLoaded;
// }

// @freezed
// abstract class VersionLoaded extends VersionState with _$VersionLoaded {
//   VersionLoaded._();

//   factory VersionLoaded({
//     final PackageInfo packageInfo,
//   }) = _VersionLoaded;
// }

import 'package:package_info_plus/package_info_plus.dart';
import 'base_state.dart';

class VersionState extends BaseState {
  const VersionState();
}

class VersionNotLoaded extends VersionState {
  const VersionNotLoaded();
}

class VersionLoaded extends VersionState {
  final PackageInfo packageInfo;

  const VersionLoaded({
    required this.packageInfo,
  });
}
