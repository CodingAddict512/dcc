import 'package:dcc/cubits/pickups_cubit.dart';
import 'package:dcc/cubits/routes_cubit.dart';
import 'package:dcc/cubits/states/pickups_state.dart';
import 'package:dcc/cubits/states/routes_state.dart';
import 'package:dcc/localization/app_localizations.dart';
import 'package:dcc/widgets/bloc_sub_state/bloc_sub_state_builder.dart';
import 'package:dcc/widgets/nav_fragment.dart';
import 'package:dcc/widgets/pickups/add_pickup_fab.dart';
import 'package:dcc/widgets/pickups/pickups_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PickupsPage extends StatelessWidget implements NavFragment {
  final EdgeInsets padding;

  @override
  final bool fullPage = false;

  PickupsPage({this.padding = EdgeInsets.zero});

  @override
  Widget build(BuildContext context) {
    final routesCubit = Provider.of<RoutesCubit>(context);
    final localizations = DccLocalizations.of(context);

    Widget loading() {
      if (routesCubit.hasAnyRoutesAssigned()) {
        return Center(child: CircularProgressIndicator());
      }
      if (routesCubit.state is RoutesLoaded) {
        return Center(child: Text(""));
      }
      return Center(child: Text(localizations.translate("pickupPagesAwaitingRoutes")));
    }

    Widget pickups() {
      return BlocSubStateBuilder<PickupsCubit, PickupsState, PickupsLoaded>(
        subStateBuilder: (context, state) => PickupsList(state.pickups),
        fallbackBuilder: (context, state) => loading(),
      );
    }

    return Padding(
      padding: EdgeInsets.only(top: 1),
      child: Scaffold(
        floatingActionButton: AddPickupFab(),
        body: Padding(
          padding: padding,
          child: pickups(),
        ),
      ),
    );
  }
}
