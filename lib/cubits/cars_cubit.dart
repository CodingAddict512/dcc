import 'dart:async';

import 'package:dcc/cubits/states/cars_state.dart';
import 'package:dcc/data/respository_interface.dart';
import 'package:dcc/models/car.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class CarsCubit extends Cubit<CarsState> {
  final IRepository repository;
  StreamSubscription listener;

  CarsCubit({@required this.repository}) : super(CarsInitial());


  factory CarsCubit.fromContext(BuildContext context) => CarsCubit(
    repository: context.read<IRepository>(),
  );


  void loadCars(String transporterId) async {
    await listener?.cancel();
    listener = null;
    emit(CarsLoading());
    listener = repository.getCars(transporterId).listen((allCars) {
      state.ifState<CarsLoaded>(withState: (s) {
        final newSelectedCar = s.selectedCar != null
            ? allCars.firstWhere(
                (element) => element.id == s.selectedCar.id,
                orElse: () => null,
              )
            : null;
        final newState = s.copyWith(
          allCars: allCars,
          selectedCar: newSelectedCar,
        );
        emit(newState);
      });
      state.ifState<CarsLoading>(withState: (s) {
        final newState = CarsLoaded(
          allCars: allCars,
          selectedCar: allCars.isNotEmpty ? allCars.first : null,
        );
        emit(newState);
      });
    });
  }

  void selectCar(Car c) {
    state.ifState<CarsLoaded>(withState: (s) {
      final newState = s.copyWith(
        selectedCar: c,
      );
      emit(newState);
    });
  }

  @override
  Future<void> close() async {
    await listener?.cancel();
    return super.close();
  }
}
