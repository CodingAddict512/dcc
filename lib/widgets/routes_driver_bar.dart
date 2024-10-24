import 'package:dcc/cubits/routes_cubit.dart';
import 'package:dcc/cubits/states/routes_state.dart';
import 'package:dcc/localization/app_localizations.dart';
import 'package:dcc/models/pickup_route.dart';
import 'package:dcc/pages/settings.dart';
import 'package:dcc/widgets/bloc_sub_state/bloc_sub_state_builder.dart';
import 'package:flutter/material.dart';
import 'package:dcc/extensions/compat.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RoutesDriverBar extends StatelessWidget {
  static const _borderRadius = 8.0;
  static const _paddingHorizontal = 8.0;
  static const _paddingTop = 8.0;
  static const _elevation = 3.0;

  RoutesDriverBar();

  @override
  Widget build(BuildContext context) {
    final routesCubit = context.watch<RoutesCubit>();
    final localizations = DccLocalizations.of(context);
    final navigator = Navigator.of(context);

    Widget loading() {
      return Center(child: CircularProgressIndicator());
    }

    Widget _routeDropDown(List<PickupRoute> routes, PickupRoute route) {
      // routes.sort((a, b) => (a.name ?? "").compareTo((b.name ?? "")));
      routes.sort((a, b) => (a.name ?? "").compareTo((b.name ?? "")));

      return DropdownButton<PickupRoute>(
          value: route,
          icon: Icon(Icons.arrow_drop_down),
          isExpanded: true,
          onChanged: (newRoute) {
            routesCubit.selectRoute(newRoute!);
          },
          items: routes
              .map((r) => DropdownMenuItem<PickupRoute>(
                    value: r,
                    child: Text(r.name),
                  ))
              .toList());
    }

    Widget _barTitle() {
      return BlocSubStateBuilder<RoutesCubit, RoutesState, RoutesLoaded>(
        subStateBuilder: (context, state) {
          final routes = state.routes;
          if (routes != null && routes.length > 0) {
            final route = state.route ?? routes.first;
            return _routeDropDown(routes, route);
          } else {
            return Text(
              localizations!.translate("routesDriverBarNoRoutes"),
            );
          }
        },
        fallbackBuilder: (context, state) => loading(),
      );
    }

    Widget _settingsButton() {
      return IconButton(
        tooltip: localizations!.translate("routesDriverBarSettings"),
        onPressed: () => navigator.push(MaterialPageRoute(
          builder: (context) => SettingsPage(),
        )),
        icon: Icon(Icons.person),
      );
    }

    return Padding(
      padding: EdgeInsets.only(
        top: _paddingTop,
        left: _paddingHorizontal,
        right: _paddingHorizontal,
      ),
      child: Material(
        borderRadius: BorderRadius.circular(_borderRadius),
        elevation: _elevation,
        child: ListTile(
          title: _barTitle(),
          trailing: _settingsButton(),
        ),
      ),
    );
  }
}
