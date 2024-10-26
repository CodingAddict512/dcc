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
