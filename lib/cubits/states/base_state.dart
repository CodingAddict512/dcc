import 'package:flutter/foundation.dart';

@immutable
abstract class BaseState {
  const BaseState();

  /// This method should be overridden with corresponding type for [state]
  /// parameter in [orElse].
  dynamic ifState<@required S>({
    dynamic Function(S state) withState,
    dynamic Function(BaseState state) orElse,
  }) {
    if (withState != null && this is S) {
      return withState(this as S);
    } else if (orElse != null) {
      return orElse(this);
    }
  }
}
