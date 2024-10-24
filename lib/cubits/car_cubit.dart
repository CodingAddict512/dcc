import 'dart:async';

import 'package:dcc/cubits/routes_cubit.dart';
import 'package:dcc/cubits/states/car_state.dart';
import 'package:dcc/cubits/states/routes_state.dart';
import 'package:dcc/models/car.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CarCubit extends Cubit<CarState> {
  final RoutesCubit routesCubit;
  StreamSubscription? onNewRoute;

  CarCubit({required this.routesCubit}) : super(CarInitial()) {
    _loadCar();
    onNewRoute = routesCubit.stream.listen((state) {
      _loadCar();
    });
  }

  factory CarCubit.fromContext(BuildContext context) => CarCubit(
        routesCubit: context.read<RoutesCubit>(),
      );

  // void _loadCar() async {
  //   routesCubit.state.ifState<RoutesLoaded>(
  //     withState: (state) async {
  //       final _car = await Car.fromReference(state.route.car);
  //       final loaded = CarLoaded(car: _car);
  //       emit(loaded);
  //     },
  //   );
  // }
  void _loadCar() async {
    routesCubit.state.ifState<RoutesLoaded>(
      withState: (state) async {
        final _car = await Car.fromReference(state.route.car);
        final loaded = CarLoaded(car: _car);
        emit(loaded);
      },
      orElse: (state) {
        // Handle any other state here if needed
        emit(CarError("Failed to load car, unexpected state: $state"));
      },
    );
  }

  @override
  Future<void> close() async {
    await onNewRoute!.cancel();
    return super.close();
  }
}
