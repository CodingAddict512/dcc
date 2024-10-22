import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dcc/cubits/states/default_locations_state.dart';
import 'package:dcc/data/respository_interface.dart';
import 'package:dcc/models/customer_stub.dart';
import 'package:dcc/models/location_distance.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:provider/provider.dart';

class PrimaryLocationsCubit extends Cubit<PrimaryLocationsState> {
  final IRepository repository;
  StreamSubscription listener;

  PrimaryLocationsCubit({@required this.repository}) : super(PrimaryLocationsInitial()) {
    _setupStream();
  }

  factory PrimaryLocationsCubit.fromContext(BuildContext context) => PrimaryLocationsCubit(
        repository: context.read<IRepository>(),
      );

  void _setupStream() async {
    await listener?.cancel();
    listener = null;
    emit(PrimaryLocationsLoading());
    listener = repository.getCustomerStubs().listen((customerStubs) {
      state.ifState<PrimaryLocationsLoaded>(withState: (s) {
        final newState = s.copyWith(locations: customerStubs);
        emit(newState);
      });
      state.ifState<PrimaryLocationsLoading>(withState: (s) {
        final newState = PrimaryLocationsLoaded(locations: customerStubs);
        emit(newState);
      });
    });
  }

  List<PrimaryLocationDistance> sortByDistance(
    GeoPoint from,
    Iterable<CustomerStub> dls,
  ) {
    final dl_distances = dls.map((dl) {
      final distance = distanceBetween(from, dl.geoLocation);
      return PrimaryLocationDistance(dl, distance);
    }).toList();

    dl_distances.sort((a, b) {
      final aDist = a.distance ?? double.maxFinite;
      final bDist = b.distance ?? double.maxFinite;
      return aDist.compareTo(bDist);
    });

    return dl_distances;
  }

  @override
  Future<void> close() async {
    await listener?.cancel();
    return super.close();
  }
}

class PrimaryLocationDistance {
  final CustomerStub primaryLocation;
  final double distance;

  PrimaryLocationDistance(this.primaryLocation, this.distance);
}
