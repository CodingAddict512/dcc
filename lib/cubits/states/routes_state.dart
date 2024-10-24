// import 'package:dcc/cubits/states/base_state.dart';
// import 'package:dcc/models/pickup_route.dart';
// import 'package:freezed_annotation/freezed_annotation.dart';

// part 'routes_state.freezed.dart';

// @immutable
// abstract class RoutesState extends BaseState {
//   const RoutesState();
// }

// @freezed
// abstract class RoutesInitial extends RoutesState with _$RoutesInitial {
//   RoutesInitial._();

//   factory RoutesInitial() = _RoutesInitial;
// }

// @freezed
// abstract class RoutesLoading extends RoutesState with _$RoutesLoading {
//   RoutesLoading._();

//   factory RoutesLoading() = _RoutesLoading;
// }

// @freezed
// abstract class RoutesLoaded extends RoutesState with _$RoutesLoaded {
//   RoutesLoaded._();

//   factory RoutesLoaded({
//     final List<PickupRoute> routes,
//     final PickupRoute route,
//   }) = _RoutesLoaded;
// }

// @freezed
// abstract class RoutesError extends RoutesState with _$RoutesError {
//   RoutesError._();

//   factory RoutesError({
//     final String message,
//   }) = _RoutesError;
// }

// import 'package:dcc/cubits/states/base_state.dart';
// import 'package:dcc/models/pickup_route.dart';

// class RoutesState extends BaseState {
//   const RoutesState();
// }

// class RoutesInitial extends RoutesState {
//   const RoutesInitial();
// }

// class RoutesLoading extends RoutesState {
//   const RoutesLoading();
// }

// class RoutesLoaded extends RoutesState {
//   final List<PickupRoute>? routes;
//   final PickupRoute route;

//   const RoutesLoaded({
//     this.routes,
//     required this.route,
//   });
// }

// class RoutesError extends RoutesState {
//   final String message;

//   const RoutesError({
//     required this.message,
//   });
// }

import 'package:dcc/cubits/states/base_state.dart';
import 'package:dcc/models/pickup_route.dart';

class RoutesState extends BaseState {
  const RoutesState();
}

class RoutesInitial extends RoutesState {
  const RoutesInitial();
}

class RoutesLoading extends RoutesState {
  const RoutesLoading();
}

class RoutesLoaded extends RoutesState {
  final List<PickupRoute>? routes;
  final PickupRoute route;

  const RoutesLoaded({
    this.routes,
    required this.route,
  });

  RoutesLoaded copyWith({
    List<PickupRoute>? routes,
    PickupRoute? route,
  }) {
    return RoutesLoaded(
      routes: routes ?? this.routes,
      route: route ?? this.route,
    );
  }
}

class RoutesError extends RoutesState {
  final String message;

  const RoutesError({
    required this.message,
  });

  RoutesError copyWith({
    String? message,
  }) {
    return RoutesError(
      message: message ?? this.message,
    );
  }
}
