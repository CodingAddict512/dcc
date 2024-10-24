import 'dart:async';

import 'package:dcc/cubits/pickup_edit_cubit.dart';
import 'package:dcc/cubits/states/pickup_edit_state.dart';
import 'package:dcc/cubits/states/receiver_locations_state.dart';
import 'package:dcc/data/respository_interface.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReceiverLocationsCubit extends Cubit<ReceiverLocationsState> {
  final IRepository repository;
  final PickupEditCubit pickupEditCubit;
  StreamSubscription? onNewCustomer;
  StreamSubscription? listener;

  ReceiverLocationsCubit(
      {required this.repository, required this.pickupEditCubit})
      : super(ReceiverLocationsInitial()) {
    if (pickupEditCubit.state is PickupEditLoaded) {
      _setupStream();
    }
    onNewCustomer = pickupEditCubit.stream
        .where((state) => state is PickupEditLoaded)
        .map((state) => state as PickupEditLoaded)
        .where((state) => state.receiverCustomer != null)
        .listen((state) {
      _setupStream();
    });
  }

  factory ReceiverLocationsCubit.fromContext(BuildContext context) =>
      ReceiverLocationsCubit(
        pickupEditCubit: context.read<PickupEditCubit>(),
        repository: context.read<IRepository>(),
      );

  void _setupStream() async {
    await listener!.cancel();
    listener = null;
    emit(ReceiverLocationsLoading());

    final pickupEditState = pickupEditCubit.state;

    if (pickupEditState is PickupEditLoaded &&
        pickupEditState.receiverCustomer != null) {
      listener = repository
          .getLocations(pickupEditState.receiverCustomer.id)
          .listen((locations) {
        state.ifState<ReceiverLocationsLoaded>(
          withState: (state) async {
            final loaded = state.copyWith(locations: locations);
            emit(loaded);
          },
          orElse: (state) {},
        );
        state.ifState<ReceiverLocationsLoading>(
          withState: (state) async {
            final loaded = ReceiverLocationsLoaded(
              locations: locations,
              recent: [],
            );
            emit(loaded);
          },
          orElse: (state) {},
        );
      });
    }
  }

  @override
  Future<void> close() async {
    await onNewCustomer!.cancel();
    await listener!.cancel();
    return super.close();
  }
}
