import 'dart:async';

import 'package:dcc/cubits/routes_cubit.dart';
import 'package:dcc/cubits/states/car_state.dart';
import 'package:dcc/cubits/states/routes_state.dart';
import 'package:dcc/models/car.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class CarCubit extends Cubit<CarState> {
  final RoutesCubit routesCubit;
  StreamSubscription onNewRoute;

  CarCubit({@required this.routesCubit}) : super(CarInitial()) {
    _loadCar();
    onNewRoute = routesCubit.listen((state) {
      _loadCar();
    });
  }

  factory CarCubit.fromContext(BuildContext context) => CarCubit(
      routesCubit: context.read<RoutesCubit>(),
  );

  void _loadCar() async {
    routesCubit.state.ifState<RoutesLoaded>(
      withState: (state) async {
        final _car = await Car.fromReference(state.route.car);
        final loaded = CarLoaded(car: _car);
        emit(loaded);
      },
    );
  }

  @override
  Future<void> close() async {
    if (onNewRoute != null) {
      await onNewRoute.cancel();
    }
    return super.close();
  }

}
