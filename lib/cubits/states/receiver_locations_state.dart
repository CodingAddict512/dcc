import 'package:dcc/cubits/states/base_state.dart';
import 'package:dcc/models/location.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ReceiverLocationsState extends BaseState {
  const ReceiverLocationsState();
}

class ReceiverLocationsInitial extends ReceiverLocationsState {
  const ReceiverLocationsInitial();
}

class ReceiverLocationsLoading extends ReceiverLocationsState {
  const ReceiverLocationsLoading();
}

class ReceiverLocationsLoaded extends ReceiverLocationsState {
  final List<Location> locations;
  final List<Location> recent;

  const ReceiverLocationsLoaded({
    required this.locations,
    required this.recent,
  });

  ReceiverLocationsLoaded copyWith({
    List<Location>? locations,
    List<Location>? recent,
  }) {
    if ((identical(locations, this.locations)) &&
        (identical(recent, this.recent))) {
      return this;
    }

    return new ReceiverLocationsLoaded(
      locations: locations ?? this.locations,
      recent: recent ?? this.recent,
    );
  }
}

class ReceiverLocationsError extends ReceiverLocationsState {
  final String message;

  const ReceiverLocationsError(this.message);
}
