import 'package:dcc/cubits/states/base_state.dart';
import 'package:dcc/models/transporter.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta/meta.dart';

part 'transporter_state.freezed.dart';

@immutable
abstract class TransporterState extends BaseState {
  const TransporterState();
}

@freezed
abstract class TransporterInitial extends TransporterState with _$TransporterInitial {
  TransporterInitial._();

  factory TransporterInitial() = _TransporterInitial;
}

@freezed
abstract class TransporterLoading extends TransporterState with _$TransporterLoading {
  TransporterLoading._();

  factory TransporterLoading() = _TransporterLoading;
}

@freezed
abstract class TransporterLoaded extends TransporterState with _$TransporterLoaded {
  TransporterLoaded._();

  factory TransporterLoaded({
    final Transporter transporter,
  }) = _TransporterLoaded;
}


@freezed
abstract class TransporterError extends TransporterState with _$TransporterError {

  TransporterError._();

  factory TransporterError({
    final String message,
  }) = _TransporterError;
}
