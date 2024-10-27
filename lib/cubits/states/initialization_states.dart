

import 'package:dcc/cubits/states/user_state.dart';
import 'base_state.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class InitializationState extends BaseState {
  const InitializationState();
}

// Progress states
abstract class InitializationProgressState extends InitializationState {
  const InitializationProgressState();
}

// Pending states
abstract class InitializationPendingExternalChangeState
    extends InitializationState {
  const InitializationPendingExternalChangeState();
}

// Final states
abstract class InitializationFinalState extends InitializationState {
  const InitializationFinalState();
}

class InitializationNotStarted extends InitializationState {
  const InitializationNotStarted();
}

class InitializationSettingsLoading extends InitializationProgressState {
  const InitializationSettingsLoading();
}

class InitializationSettingsLoaded extends InitializationState {
  const InitializationSettingsLoaded();
}

class InitializationUserLoading extends InitializationProgressState {
  const InitializationUserLoading();
}

class InitializationUserNoCredentials
    extends InitializationPendingExternalChangeState {
  const InitializationUserNoCredentials();
}

class InitializationUserPerformingLogin extends InitializationProgressState {
  const InitializationUserPerformingLogin();
}

class InitializationUserInitialized extends InitializationState {
  const InitializationUserInitialized();

  // Optional: add a copyWith method in case you want to add properties later
  InitializationUserInitialized copyWith() {
    return const InitializationUserInitialized();
  }
}

class InitializationUserNeedsReset
    extends InitializationPendingExternalChangeState {
  final UserError userError;

  const InitializationUserNeedsReset({
    required this.userError,
  });

  InitializationUserNeedsReset copyWith({
    UserError? userError,
  }) {
    return InitializationUserNeedsReset(
      userError: userError ?? this.userError,
    );
  }
}

class InitializationComplete extends InitializationFinalState {
  const InitializationComplete();
}

class InitializationError extends InitializationFinalState {
  final InitializationState previousState;
  final String errorMessage;

  const InitializationError({
    required this.previousState,
    required this.errorMessage,
  });

  InitializationError copyWith({
    InitializationState? previousState,
    String? errorMessage,
  }) {
    return InitializationError(
      previousState: previousState ?? this.previousState,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class InitializationInProgress extends InitializationState {}
