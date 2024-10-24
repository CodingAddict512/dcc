// import 'package:dcc/cubits/states/base_state.dart';
// import 'package:dcc/models/pickup.dart';
// import 'package:freezed_annotation/freezed_annotation.dart';

// part 'pickups_state.freezed.dart';

// @immutable
// abstract class PickupsState extends BaseState {
//   const PickupsState();
// }

// @freezed
// abstract class PickupsInitial extends PickupsState with _$PickupsInitial {
//   PickupsInitial._();

//   factory PickupsInitial() = _PickupsInitial;
// }

// @freezed
// abstract class PickupsLoading extends PickupsState with _$PickupsLoading {
//   PickupsLoading._();

//   factory PickupsLoading() = _PickupsLoading;
// }

// @freezed
// abstract class PickupsLoaded extends PickupsState with _$PickupsLoaded {
//   PickupsLoaded._();

//   factory PickupsLoaded({
//     final List<Pickup> pickups,
//     final Pickup pickup,
//   }) = _PickupsLoaded;
// }

// @freezed
// abstract class PickupsError extends PickupsState with _$PickupsError {
//   PickupsError._();

//   factory PickupsError(final String message) = _PickupsError;
// }

// import 'package:dcc/cubits/states/base_state.dart';
// import 'package:dcc/models/pickup.dart';

// class PickupsState extends BaseState {
//   const PickupsState();
// }

// class PickupsInitial extends PickupsState {
//   const PickupsInitial();
// }

// class PickupsLoading extends PickupsState {
//   const PickupsLoading();
// }

// class PickupsLoaded extends PickupsState {
//   final List<Pickup> pickups;
//   final Pickup pickup;

//   const PickupsLoaded({
//     required this.pickups,
//     required this.pickup,
//   });
// }

// class PickupsError extends PickupsState {
//   final String message;

//   const PickupsError(this.message);
// }

import 'package:dcc/cubits/states/base_state.dart';
import 'package:dcc/models/pickup.dart';

class PickupsState extends BaseState {
  const PickupsState();
}

class PickupsInitial extends PickupsState {
  const PickupsInitial();
}

class PickupsLoading extends PickupsState {
  const PickupsLoading();
}

class PickupsLoaded extends PickupsState {
  final List<Pickup> pickups;
  final Pickup pickup;

  const PickupsLoaded({
    required this.pickups,
    required this.pickup,
  });

  PickupsLoaded copyWith({
    List<Pickup>? pickups,
    Pickup? pickup,
  }) {
    return PickupsLoaded(
      pickups: pickups ?? this.pickups,
      pickup: pickup ?? this.pickup,
    );
  }
}

class PickupsError extends PickupsState {
  final String message;

  const PickupsError(this.message);
}
