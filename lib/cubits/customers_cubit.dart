import 'dart:async';

import 'package:dcc/cubits/states/customers_state.dart';
import 'package:dcc/data/respository_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class CustomersCubit extends Cubit<CustomersState> {
  final IRepository repository;
  StreamSubscription listener;

  CustomersCubit({@required this.repository}) : super(CustomersInitial()) {
    _setupStream();
  }

  factory CustomersCubit.fromContext(BuildContext context) => CustomersCubit(
    repository: context.read<IRepository>(),
  );


  void _setupStream() async {
    await listener?.cancel();
    listener = null;
    emit(CustomersLoading());
    listener = repository.getCustomerStubs().listen((customerStubs) async {
      final defaultReceiverSub = customerStubs.firstWhere(
              (element) => element.isDefaultReceiver,
              orElse: () => null
      );
      final defaultReceiver = defaultReceiverSub != null
          ? await defaultReceiverSub.resolveCustomer()
          : null;
      state.ifState<CustomerStubsLoaded>(withState: (s) {
        final newState = s.copyWith(
          customerStubs: customerStubs,
          defaultReceiver: defaultReceiver,
        );
        emit(newState);
      });
      state.ifState<CustomersLoading>(withState: (s) {
        final newState = CustomerStubsLoaded(
          customerStubs: customerStubs,
          recent: [],
          defaultReceiver: defaultReceiver,
        );
        emit(newState);
      });
    });
  }

  @override
  Future<void> close() async {
    await listener?.cancel();
    return super.close();
  }
}
