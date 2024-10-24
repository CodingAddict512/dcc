import 'package:dcc/cubits/states/base_state.dart';
import 'package:dcc/models/customer.dart';
import 'package:dcc/models/customer_stub.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CustomersState extends BaseState {
  const CustomersState();
}

class CustomersInitial extends CustomersState {
  const CustomersInitial();
}

class CustomersLoading extends CustomersState {
  const CustomersLoading();
}

class CustomerStubsLoaded extends CustomersState {
  final List<CustomerStub> customerStubs;
  final List<CustomerStub> recent;
  final Customer defaultReceiver;

  const CustomerStubsLoaded({
    required this.customerStubs,
    required this.recent,
    required this.defaultReceiver,
  });

  CustomerStubsLoaded copyWith({
    List<CustomerStub>? customerStubs,
    List<CustomerStub>? recent,
    Customer? defaultReceiver,
  }) {
    if ((identical(customerStubs, this.customerStubs)) &&
        (identical(recent, this.recent)) &&
        (defaultReceiver == null ||
            identical(defaultReceiver, this.defaultReceiver))) {
      return this;
    }

    return new CustomerStubsLoaded(
      customerStubs: customerStubs ?? this.customerStubs,
      recent: recent ?? this.recent,
      defaultReceiver: defaultReceiver!,
    );
  }
}

class CustomersError extends CustomersState {
  final String message;

  const CustomersError(this.message);
}
