import 'dart:async';

import 'package:dcc/cubits/pickup_edit_cubit.dart';
import 'package:dcc/cubits/states/origin_locations_state.dart';
import 'package:dcc/cubits/states/pickup_edit_state.dart';
import 'package:dcc/data/respository_interface.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:dcc/extensions/compat.dart';

class OriginLocationsCubit extends Cubit<OriginLocationsState> {
  final IRepository repository;
  final PickupEditCubit pickupEditCubit;
  StreamSubscription onNewCustomer;
  StreamSubscription listener;

  OriginLocationsCubit({@required this.repository, @required this.pickupEditCubit}) : super(OriginLocationsInitial()) {
    if (pickupEditCubit.state is PickupEditLoaded) {
      _setupStream();
    }
    onNewCustomer = pickupEditCubit.stream
        .where((state) => state is PickupEditLoaded)
        .map((state) => state as PickupEditLoaded)
        .where((state) => state.originCustomer != null)
        .listen((state) {
      _setupStream();
    });
  }

  factory OriginLocationsCubit.fromContext(BuildContext context) => OriginLocationsCubit(
    pickupEditCubit: context.read<PickupEditCubit>(),
    repository: context.read<IRepository>(),
  );


  void _setupStream() async {
    await listener?.cancel();
    listener = null;
    emit(OriginLocationsLoading());

    final pickupEditState = pickupEditCubit.state;

    if (pickupEditState is PickupEditLoaded && pickupEditState.originCustomer != null) {
      listener = repository.getLocations(pickupEditState.originCustomer.id).listen((locations) {
        state.ifState<OriginLocationsLoaded>(withState: (state) async {
          final loaded = state.copyWith(locations: locations);
          emit(loaded);
        });
        state.ifState<OriginLocationsLoading>(withState: (state) async {
          final loaded = OriginLocationsLoaded(
            locations: locations,
            recent: [],
          );
          emit(loaded);
        });
      });
    }
  }

  @override
  Future<void> close() async {
    if (onNewCustomer != null) {
      await onNewCustomer.cancel();
    }
    if (listener != null) {
      await listener.cancel();
    }
    return super.close();
  }
}
