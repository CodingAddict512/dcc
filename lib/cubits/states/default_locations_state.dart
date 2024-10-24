import 'package:dcc/cubits/states/base_state.dart';
import 'package:dcc/models/customer_stub.dart';
import 'package:meta/meta.dart';

@immutable
abstract class PrimaryLocationsState extends BaseState {
  const PrimaryLocationsState();
}

class PrimaryLocationsInitial extends PrimaryLocationsState {
  const PrimaryLocationsInitial();
}

class PrimaryLocationsLoading extends PrimaryLocationsState {
  const PrimaryLocationsLoading();
}

class PrimaryLocationsLoaded extends PrimaryLocationsState {
  final List<CustomerStub> locations;

  const PrimaryLocationsLoaded({required this.locations});

  PrimaryLocationsLoaded copyWith({
    List<CustomerStub>? locations,
  }) {
    if ((identical(locations, this.locations))) {
      return this;
    }

    return new PrimaryLocationsLoaded(
      locations: locations ?? this.locations,
    );
  }
}

class PrimaryLocationsError extends PrimaryLocationsState {
  final String message;

  const PrimaryLocationsError(this.message);
}
