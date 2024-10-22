import 'package:dcc/cubits/states/user_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta/meta.dart';

import 'base_state.dart';

part 'initialization_states.freezed.dart';

@immutable
abstract class InitializationState extends BaseState {
  const InitializationState();
}

// Progress states - the InitializationCubit state machine ignores
// these, but they can be used to let the user know what they are
// waiting for.
abstract class InitializationProgressState extends InitializationState {
  const InitializationProgressState();
}

// Pending states - the InitializationCubit emits these when it waits
// for an external thing (e.g. subscribes to another cubit).  It is
// mostly useful as a tagging/debugging type plus the UI can subscribe
// to these and tell whether or not it should do something.
abstract class InitializationPendingExternalChangeState extends InitializationState {
  const InitializationPendingExternalChangeState();
}

// Final states - the InitializationCubit emits one of these when it
// cannot progress any further.  This should be either "all ok" or
// an error state.
abstract class InitializationFinalState extends InitializationState {
  const InitializationFinalState();
}



@freezed
abstract class InitializationNotStarted extends InitializationState with _$InitializationNotStarted {
  InitializationNotStarted._();

  factory InitializationNotStarted() = _InitializationNotStarted;
}

@freezed
abstract class InitializationSettingsLoading extends InitializationProgressState with _$InitializationSettingsLoading {
  InitializationSettingsLoading._();

  factory InitializationSettingsLoading() = _InitializationSettingsLoading;
}

@freezed
abstract class InitializationSettingsLoaded extends InitializationState with _$InitializationSettingsLoaded {
  InitializationSettingsLoaded._();

  factory InitializationSettingsLoaded() = _InitializationSettingsLoaded;
}

@freezed
abstract class InitializationUserLoading extends InitializationProgressState with _$InitializationUserLoading {
  InitializationUserLoading._();

  factory InitializationUserLoading() = _InitializationUserLoading;
}

@freezed
abstract class InitializationUserNoCredentials extends InitializationPendingExternalChangeState with _$InitializationUserNoCredentials {
  InitializationUserNoCredentials._();

  factory InitializationUserNoCredentials() = _InitializationUserNoCredentials;
}

@freezed
abstract class InitializationUserPerformingLogin extends InitializationProgressState with _$InitializationUserPerformingLogin {
  InitializationUserPerformingLogin._();

  factory InitializationUserPerformingLogin() = _InitializationUserPerformingLogin;
}

@freezed
abstract class InitializationUserInitialized extends InitializationState with _$InitializationUserInitialized {
  InitializationUserInitialized._();

  factory InitializationUserInitialized() = _InitializationUserInitialized;
}


@freezed
abstract class InitializationUserNeedsReset extends InitializationPendingExternalChangeState with _$InitializationUserNeedsReset {
  InitializationUserNeedsReset._();

  factory InitializationUserNeedsReset({
    final UserError userError,
  }) = _InitializationUserNeedsReset;
}

@freezed
abstract class InitializationComplete extends InitializationFinalState  with _$InitializationComplete {
  InitializationComplete._();

  factory InitializationComplete() = _InitializationComplete;
}

@freezed
abstract class InitializationError extends InitializationFinalState with _$InitializationError {
  InitializationError._();

  factory InitializationError({
    InitializationState previousState,
    String errorMessage,
  }) = _InitializationError;
}
