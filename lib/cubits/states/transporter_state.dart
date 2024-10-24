// import 'package:dcc/cubits/states/base_state.dart';
// import 'package:dcc/models/transporter.dart';
// import 'package:freezed_annotation/freezed_annotation.dart';

// part 'transporter_state.freezed.dart';

// @immutable
// abstract class TransporterState extends BaseState {
//   const TransporterState();
// }

// @freezed
// abstract class TransporterInitial extends TransporterState with _$TransporterInitial {
//   TransporterInitial._();

//   factory TransporterInitial() = _TransporterInitial;
// }

// @freezed
// abstract class TransporterLoading extends TransporterState with _$TransporterLoading {
//   TransporterLoading._();

//   factory TransporterLoading() = _TransporterLoading;
// }

// @freezed
// abstract class TransporterLoaded extends TransporterState with _$TransporterLoaded {
//   TransporterLoaded._();

//   factory TransporterLoaded({
//     final Transporter transporter,
//   }) = _TransporterLoaded;
// }

// @freezed
// abstract class TransporterError extends TransporterState with _$TransporterError {

//   TransporterError._();

//   factory TransporterError({
//     final String message,
//   }) = _TransporterError;
// }

import 'package:dcc/cubits/states/base_state.dart';
import 'package:dcc/models/transporter.dart';

class TransporterState extends BaseState {
  const TransporterState();
}

class TransporterInitial extends TransporterState {
  const TransporterInitial();
}

class TransporterLoading extends TransporterState {
  const TransporterLoading();
}

class TransporterLoaded extends TransporterState {
  final Transporter transporter;

  const TransporterLoaded({
    required this.transporter,
  });
}

class TransporterError extends TransporterState {
  final String message;

  const TransporterError({
    required this.message,
  });
}
