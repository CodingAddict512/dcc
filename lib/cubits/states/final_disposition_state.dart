import 'package:dcc/cubits/states/base_state.dart';
import 'package:dcc/models/final_disposition.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta/meta.dart';

part 'final_disposition_state.freezed.dart';

@immutable
abstract class FinalDispositionState extends BaseState {
  const FinalDispositionState();
}

@freezed
abstract class FinalDispositionStateInitial extends FinalDispositionState with _$FinalDispositionStateInitial {
  FinalDispositionStateInitial._();

  factory FinalDispositionStateInitial() = _FinalDispositionStateInitial;
}

@freezed
abstract class FinalDispositionStateLoading extends FinalDispositionState with _$FinalDispositionStateLoading {
  FinalDispositionStateLoading._();

  factory FinalDispositionStateLoading() = _FinalDispositionStateLoading;
}

@freezed
abstract class FinalDispositionStateNoFinalDispositions extends FinalDispositionState with _$FinalDispositionStateNoFinalDispositions {
  FinalDispositionStateNoFinalDispositions._();

  factory FinalDispositionStateNoFinalDispositions() = _FinalDispositionStateNoFinalDispositions;
}

@freezed
abstract class FinalDispositionStateLoaded extends FinalDispositionState with _$FinalDispositionStateLoaded {
  FinalDispositionStateLoaded._();

  factory FinalDispositionStateLoaded({
    final Map<int, FinalDisposition> id2disposition,
    final List<FinalDisposition> dispositions,
    final FinalDisposition selectedFinalDisposition,
  }) = _FinalDispositionStateLoaded;
}

@freezed
abstract class FinalDispositionStateError extends FinalDispositionState with _$FinalDispositionStateError {
  FinalDispositionStateError._();

  factory FinalDispositionStateError({
    final String message,
  }) = _FinalDispositionStateError;
}
