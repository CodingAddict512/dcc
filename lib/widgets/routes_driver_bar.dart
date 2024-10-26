// import 'package:dcc/cubits/routes_cubit.dart';
// import 'package:dcc/cubits/states/routes_state.dart';
// import 'package:dcc/localization/app_localizations.dart';
// import 'package:dcc/models/pickup_route.dart';
// import 'package:dcc/pages/settings.dart';
// import 'package:dcc/widgets/bloc_sub_state/bloc_sub_state_builder.dart';
// import 'package:flutter/material.dart';
// import 'package:dcc/extensions/compat.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:provider/provider.dart';

// class RoutesDriverBar extends StatelessWidget {
//   static const _borderRadius = 8.0;
//   static const _paddingHorizontal = 8.0;
//   static const _paddingTop = 8.0;
//   static const _elevation = 3.0;

//   RoutesDriverBar();

//   @override
//   Widget build(BuildContext context) {
//     final routesCubit = Provider.of<RoutesCubit>(context);
//     final localizations = DccLocalizations.of(context);
//     final navigator = Navigator.of(context);

//     Widget loading() {
//       return Center(child: CircularProgressIndicator());
//     }

//     Widget _routeDropDown(List<PickupRoute> routes, PickupRoute route) {
//       // routes.sort((a, b) => (a.name ?? "").compareTo((b.name ?? "")));
//       routes.sort((a, b) => (a.name ?? "").compareTo((b.name ?? "")));

//       return DropdownButton<PickupRoute>(
//           value: route,
//           icon: Icon(Icons.arrow_drop_down),
//           isExpanded: true,
//           onChanged: (newRoute) {
//             routesCubit.selectRoute(newRoute!);
//           },
//           items: routes
//               .map((r) => DropdownMenuItem<PickupRoute>(
//                     value: r,
//                     child: Text(r.name),
//                   ))
//               .toList());
//     }

//     Widget _barTitle() {
//       return BlocSubStateBuilder<RoutesCubit, RoutesState, RoutesLoaded>(
//         subStateBuilder: (context, state) {
//           final routes = state.routes;
//           if (routes != null && routes.length > 0) {
//             final route = state.route ?? routes.first;
//             return _routeDropDown(routes, route);
//           } else {
//             return Text(
//               localizations!.translate("routesDriverBarNoRoutes"),
//             );
//           }
//         },
//         fallbackBuilder: (context, state) => loading(),
//       );
//     }

//     Widget _settingsButton() {
//       return IconButton(
//         tooltip: localizations!.translate("routesDriverBarSettings"),
//         onPressed: () => navigator.push(MaterialPageRoute(
//           builder: (context) => SettingsPage(),
//         )),
//         icon: Icon(Icons.person),
//       );
//     }

//     return Padding(
//       padding: EdgeInsets.only(
//         top: _paddingTop,
//         left: _paddingHorizontal,
//         right: _paddingHorizontal,
//       ),
//       child: Material(
//         borderRadius: BorderRadius.circular(_borderRadius),
//         elevation: _elevation,
//         child: ListTile(
//           title: _barTitle(),
//           trailing: _settingsButton(),
//         ),
//       ),
//     );
//   }
// }

// import 'package:dcc/cubits/routes_cubit.dart';
// import 'package:dcc/cubits/states/routes_state.dart';
// import 'package:dcc/localization/app_localizations.dart';
// import 'package:dcc/models/pickup_route.dart';
// import 'package:dcc/pages/settings.dart';
// import 'package:dcc/widgets/bloc_sub_state/bloc_sub_state_builder.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:provider/provider.dart';

// class RoutesDriverBar extends StatelessWidget {
//   static const _borderRadius = 8.0;
//   static const _paddingHorizontal = 8.0;
//   static const _paddingTop = 8.0;
//   static const _elevation = 3.0;

//   RoutesDriverBar();

//   @override
//   Widget build(BuildContext context) {
//     final routesCubit = Provider.of<RoutesCubit>(context);
//     final localizations = DccLocalizations.of(context);
//     final navigator = Navigator.of(context);

//     // Ensure that localizations is not null
//     if (localizations == null) {
//       return Center(child: CircularProgressIndicator());
//     }

//     Widget loading() {
//       return Center(child: CircularProgressIndicator());
//     }

//     Widget _routeDropDown(List<PickupRoute> routes, PickupRoute? route) {
//       // Sort routes, handle potential null for name
//       routes.sort((a, b) => (a.name ?? "").compareTo((b.name ?? "")));

//       return DropdownButton<PickupRoute>(
//         value: route,
//         icon: Icon(Icons.arrow_drop_down),
//         isExpanded: true,
//         onChanged: (newRoute) {
//           // Only use newRoute if it's not null
//           if (newRoute != null) {
//             routesCubit.selectRoute(newRoute);
//           }
//         },
//         items: routes.map((r) {
//           return DropdownMenuItem<PickupRoute>(
//             value: r,
//             child:
//                 Text(r.name ?? "Unnamed Route"), // Handle potential null name
//           );
//         }).toList(),
//       );
//     }

//     Widget _barTitle() {
//       return BlocSubStateBuilder<RoutesCubit, RoutesState, RoutesLoaded>(
//         subStateBuilder: (context, state) {
//           final routes = state.routes;
//           if (routes != null && routes.isNotEmpty) {
//             final route = state.route ?? routes.first;
//             return _routeDropDown(routes, route);
//           } else {
//             return Text(localizations.translate("routesDriverBarNoRoutes"));
//           }
//         },
//         fallbackBuilder: (context, state) => loading(),
//       );
//     }

//     Widget _settingsButton() {
//       return IconButton(
//         tooltip: localizations.translate("routesDriverBarSettings"),
//         onPressed: () => navigator.push(
//           MaterialPageRoute(
//             builder: (context) => SettingsPage(),
//           ),
//         ),
//         icon: Icon(Icons.person),
//       );
//     }

//     return Padding(
//       padding: EdgeInsets.only(
//         top: _paddingTop,
//         left: _paddingHorizontal,
//         right: _paddingHorizontal,
//       ),
//       child: Material(
//         borderRadius: BorderRadius.circular(_borderRadius),
//         elevation: _elevation,
//         child: ListTile(
//           title: _barTitle(),
//           trailing: _settingsButton(),
//         ),
//       ),
//     );
//   }
// }

import 'package:dcc/cubits/routes_cubit.dart';
import 'package:dcc/cubits/states/routes_state.dart';
import 'package:dcc/localization/app_localizations.dart';
import 'package:dcc/models/pickup_route.dart';
import 'package:dcc/pages/settings.dart';
import 'package:dcc/widgets/bloc_sub_state/bloc_sub_state_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class RoutesDriverBar extends StatelessWidget {
  static const _borderRadius = 8.0;
  static const _paddingHorizontal = 8.0;
  static const _paddingTop = 8.0;
  static const _elevation = 3.0;

  @override
  Widget build(BuildContext context) {
    print("Building RoutesDriverBar...");

    // Ensure RoutesCubit is available
    final routesCubit = context.read<RoutesCubit>();
    if (routesCubit == null) {
      print("RoutesCubit not found in context");
      return Center(child: CircularProgressIndicator());
    }

    final localizations = DccLocalizations.of(context);
    if (localizations == null) {
      print("Localization not available");
      return Center(child: CircularProgressIndicator());
    }

    print("Localization loaded, building widget");

    Widget loading() {
      return Center(child: CircularProgressIndicator());
    }

    Widget _routeDropDown(List<PickupRoute> routes, PickupRoute? route) {
      routes.sort((a, b) => (a.name ?? "").compareTo((b.name ?? "")));

      return DropdownButton<PickupRoute>(
        value: route,
        icon: Icon(Icons.arrow_drop_down),
        isExpanded: true,
        onChanged: (newRoute) {
          if (newRoute != null) {
            routesCubit.selectRoute(newRoute);
          }
        },
        items: routes.map((r) {
          return DropdownMenuItem<PickupRoute>(
            value: r,
            child: Text(r.name ?? "Unnamed Route"),
          );
        }).toList(),
      );
    }

    Widget _barTitle() {
      return BlocSubStateBuilder<RoutesCubit, RoutesState, RoutesLoaded>(
        subStateBuilder: (context, state) {
          // Handle the different states explicitly
          if (state is RoutesInitial) {
            return Text(localizations
                .translate("routesDriverBarLoading")); // Show a loading message
          } else if (state is RoutesLoaded) {
            final routes = state.routes;
            if (routes != null && routes.isNotEmpty) {
              final route = state.route ?? routes.first;
              return _routeDropDown(routes, route);
            } else {
              return Text(localizations.translate("routesDriverBarNoRoutes"));
            }
          } else if (state is RoutesError) {
            return Text(localizations.translate("routesDriverBarError") +
                ": ${state.route.allOrders}"); // Handle potential errors
          } else {
            return Text(localizations.translate(
                "routesDriverBarUnknownState")); // Fallback for unknown state
          }
        },
        fallbackBuilder: (context, state) {
          print("Loading state encountered: $state");
          return loading(); // Fallback loading widget
        },
      );
    }

    Widget _settingsButton() {
      return IconButton(
        tooltip: localizations.translate("routesDriverBarSettings"),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SettingsPage(),
          ),
        ),
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
