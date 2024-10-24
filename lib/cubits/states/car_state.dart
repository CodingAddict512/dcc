import 'package:dcc/cubits/states/base_state.dart';
import 'package:dcc/models/car.dart';
import 'package:meta/meta.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'car_state.freezed.dart';

@immutable
abstract class CarState extends BaseState {
  const CarState();
}

class CarInitial extends CarState {
  const CarInitial();
}

class CarLoading extends CarState {
  const CarLoading();
}

@freezed
abstract class CarLoaded extends CarState with _$CarLoaded {
  CarLoaded._();

  factory CarLoaded({
    final Car car,
  }) = _CarLoaded;
}

class CarError extends CarState {
  final String message;

  const CarError(this.message);
}
