import 'package:dcc/cubits/origin_locations_cubit.dart';
import 'package:dcc/cubits/pickup_edit_cubit.dart';
import 'package:dcc/cubits/states/origin_locations_state.dart';
import 'package:dcc/cubits/states/pickup_edit_state.dart';
import 'package:dcc/localization/app_localizations.dart';
import 'package:dcc/models/location.dart';
import 'package:dcc/widgets/bloc_sub_state/bloc_sub_state_builder.dart';
import 'package:dcc/widgets/pickup_edit/location_selection.dart';
import 'package:flutter/material.dart';
import 'package:dcc/extensions/compat.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OriginLocationSelection extends StatelessWidget {
  Widget loading() => Text("");

  @override
  Widget build(BuildContext context) {
    final pickupEditCubit = context.watch<PickupEditCubit>();

    return BlocSubStateBuilder<OriginLocationsCubit, OriginLocationsState,
        OriginLocationsLoaded>(
      subStateBuilder: (context, originLocationsLoaded) {
        return BlocSubStateBuilder<PickupEditCubit, PickupEditState,
            PickupEditLoaded>(
          subStateBuilder: (BuildContext context, pickupEditLoaded) {
            Location location = pickupEditLoaded.originLocation;

            return LocationSelection(
              title: location.name ??
                  DccLocalizations.of(context)!
                      .translate("originLocationSelectionEmpty"),
              onSelection: pickupEditCubit.selectOriginLocation,
              locations: originLocationsLoaded.locations,
              recent: originLocationsLoaded.recent,
            );
          },
          fallbackBuilder: (context, state) => loading(),
        );
      },
      fallbackBuilder: (context, state) => loading(),
    );
  }
}
