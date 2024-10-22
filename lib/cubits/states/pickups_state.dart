import 'package:dcc/cubits/states/base_state.dart';
import 'package:dcc/models/pickup.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pickups_state.freezed.dart';

@immutable
abstract class PickupsState extends BaseState {
  const PickupsState();
}

@freezed
abstract class PickupsInitial extends PickupsState with _$PickupsInitial {
  PickupsInitial._();

  factory PickupsInitial() = _PickupsInitial;
}

@freezed
abstract class PickupsLoading extends PickupsState with _$PickupsLoading {
  PickupsLoading._();

  factory PickupsLoading() = _PickupsLoading;
}

@freezed
abstract class PickupsLoaded extends PickupsState with _$PickupsLoaded {
  PickupsLoaded._();

  factory PickupsLoaded({
    final List<Pickup> pickups,
    final Pickup pickup,
  }) = _PickupsLoaded;
}

@freezed
abstract class PickupsError extends PickupsState with _$PickupsError {
  PickupsError._();

  factory PickupsError(final String message) = _PickupsError;
}
