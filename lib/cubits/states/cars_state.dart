import 'package:dcc/cubits/states/base_state.dart';
import 'package:dcc/models/car.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CarsState extends BaseState {
  const CarsState();
}

class CarsInitial extends CarsState {
  const CarsInitial();
}

class CarsLoading extends CarsState {
  const CarsLoading();
}

class CarsLoaded extends CarsState {
  final List<Car> allCars;
  final Car selectedCar;

  const CarsLoaded({
    this.allCars,
    this.selectedCar,
  });

  CarsLoaded copyWith({
    List<Car> allCars,
    Car selectedCar,
  }) {
    if ((allCars == null || identical(allCars, this.allCars)) &&
        (selectedCar == null || identical(selectedCar, this.selectedCar))) {
      return this;
    }

    return new CarsLoaded(
      allCars: allCars ?? this.allCars,
      selectedCar: selectedCar ?? this.selectedCar,
    );
  }
}

class CarsError extends CarsState {
  final String message;

  const CarsError(this.message);
}
