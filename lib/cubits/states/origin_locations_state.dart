import 'package:dcc/cubits/states/base_state.dart';
import 'package:dcc/models/location.dart';
import 'package:meta/meta.dart';

@immutable
abstract class OriginLocationsState extends BaseState {
  const OriginLocationsState();
}

class OriginLocationsInitial extends OriginLocationsState {
  const OriginLocationsInitial();
}

class OriginLocationsLoading extends OriginLocationsState {
  const OriginLocationsLoading();
}

class OriginLocationsLoaded extends OriginLocationsState {
  final List<Location> locations;
  final List<Location> recent;

  const OriginLocationsLoaded({
    required this.locations,
    required this.recent,
  });

  OriginLocationsLoaded copyWith({
    List<Location>? locations,
    List<Location>? recent,
  }) {
    if ((identical(locations, this.locations)) &&
        (identical(recent, this.recent))) {
      return this;
    }

    return new OriginLocationsLoaded(
      locations: locations ?? this.locations,
      recent: recent ?? this.recent,
    );
  }
}

class OriginLocationsError extends OriginLocationsState {
  final String message;

  const OriginLocationsError(this.message);
}
