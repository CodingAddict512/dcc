import 'package:dcc/cubits/pickup_edit_cubit.dart';
import 'package:dcc/cubits/receiver_locations_cubit.dart';
import 'package:dcc/cubits/states/pickup_edit_state.dart';
import 'package:dcc/cubits/states/receiver_locations_state.dart';
import 'package:dcc/localization/app_localizations.dart';
import 'package:dcc/models/location.dart';
import 'package:dcc/widgets/bloc_sub_state/bloc_sub_state_builder.dart';
import 'package:dcc/widgets/pickup_edit/location_selection.dart';
import 'package:flutter/material.dart';
import 'package:dcc/extensions/compat.dart';

class ReceiverLocationSelection extends StatelessWidget {
  Widget loading() => Text("");

  @override
  Widget build(BuildContext context) {
    final pickupEditCubit = context.watch<PickupEditCubit>();

    return BlocSubStateBuilder<ReceiverLocationsCubit, ReceiverLocationsState,
        ReceiverLocationsLoaded>(
      subStateBuilder: (context, receiverLocationsLoaded) {
        return BlocSubStateBuilder<PickupEditCubit, PickupEditState,
            PickupEditLoaded>(
          subStateBuilder: (BuildContext context, pickupEditLoaded) {
            Location location = pickupEditLoaded.receiverLocation;

            return LocationSelection(
              title: location?.name ??
                  DccLocalizations.of(context)
                      .translate("receiverLocationSelectionEmpty"),
              onSelection: pickupEditCubit.selectReceiverLocation,
              locations: receiverLocationsLoaded.locations,
              recent: receiverLocationsLoaded.recent,
            );
          },
          fallbackBuilder: (context, state) => loading(),
        );
      },
      fallbackBuilder: (context, state) => loading(),
    );
  }
}
