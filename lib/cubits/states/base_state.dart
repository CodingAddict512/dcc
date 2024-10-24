// import 'package:flutter/foundation.dart';

// @immutable
// abstract class BaseState {
//   const BaseState();

//   /// This method should be overridden with corresponding type for [state]
//   /// parameter in [orElse].
//   dynamic ifState<@required S>({
//     dynamic Function(S state) withState,
//     dynamic Function(BaseState state) orElse,
//   }) {
//     if (this is S) {
//       return withState(this as S);
//     } else
//       return orElse(this);
//   }
// }

import 'package:flutter/foundation.dart';

@immutable
abstract class BaseState {
  const BaseState();

  /// This method should be overridden with the corresponding type for [state]
  /// parameter in [orElse].
  dynamic ifState<S>({
    required dynamic Function(S state) withState, // Marked as required
    required dynamic Function(BaseState state) orElse, // Marked as required
  }) {
    if (this is S) {
      return withState(this as S);
    } else {
      return orElse(this);
    }
  }
}
