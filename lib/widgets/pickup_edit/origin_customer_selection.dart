import 'package:dcc/cubits/customers_cubit.dart';
import 'package:dcc/cubits/pickup_edit_cubit.dart';
import 'package:dcc/cubits/states/customers_state.dart';
import 'package:dcc/cubits/states/pickup_edit_state.dart';
import 'package:dcc/localization/app_localizations.dart';
import 'package:dcc/models/customer.dart';
import 'package:dcc/widgets/bloc_sub_state/bloc_sub_state_builder.dart';
import 'package:dcc/widgets/pickup_edit/customer_selection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OriginCustomerSelection extends StatelessWidget {
  final bool enabled;

  OriginCustomerSelection({
    this.enabled = true,
  });

  Widget loading() => CircularProgressIndicator();

  @override
  Widget build(BuildContext context) {
    final pickupEditCubit = Provider.of<PickupEditCubit>(context);

    return BlocSubStateBuilder<CustomersCubit, CustomersState,
        CustomerStubsLoaded>(
      subStateBuilder: (context, customersLoaded) {
        return BlocSubStateBuilder<PickupEditCubit, PickupEditState,
            PickupEditLoaded>(
          subStateBuilder: (BuildContext context, pickupEditLoaded) {
            Customer customer = pickupEditLoaded.originCustomer;

            return CustomerSelection(
              title: customer.name ??
                  DccLocalizations.of(context)!
                      .translate("originCustomerSelectionEmpty"),
              onSelection: pickupEditCubit.selectOriginCustomer,
              customers: customersLoaded.customerStubs,
              recent: customersLoaded.recent,
              enabled: enabled,
            );
          },
          fallbackBuilder: (context, state) => loading(),
        );
      },
      fallbackBuilder: (context, state) => loading(),
    );
  }
}
