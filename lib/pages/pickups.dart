import 'dart:async';
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dcc/cubits/user_cubit.dart';
import 'package:dcc/data/repositories/pickup_repository_interface.dart';
import 'package:dcc/data/repositories/routes_repository_interface.dart';
import 'package:dcc/localization/app_localizations.dart';
import 'package:dcc/models/customer.dart';
import 'package:dcc/models/pickup.dart';
import 'package:dcc/models/pickup_route.dart';
import 'package:dcc/models/user.dart';
import 'package:dcc/models/user_error_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../cubits/states/user_state.dart';
import '../widgets/pickups/pickup_group.dart';

class PickupsPage extends StatefulWidget {
  final EdgeInsets padding;

  PickupsPage({this.padding = EdgeInsets.zero});

  @override
  State<PickupsPage> createState() => _PickupsPageState();
}

class _PickupsPageState extends State<PickupsPage> {
  StreamSubscription? _userListener;
  StreamSubscription? _routeListener;
  List<Pickup> pickups = [];
  String errorMessage = "";
  bool isLoading = true;
  PickupRoute? selectedRoute;

  @override
  void initState() {
    super.initState();
    print("Pick Up Page initialized.");
    final userCubit = context.read<IUserCubit>();
    final routesRepository = context.read<IRoutesRepository>();

    // Check if the user is logged in
    if (userCubit.state is UserLoggedIn) {
      final userState = userCubit.state as UserLoggedIn;
      print(
          "User is logged in: Driver ID: ${userState.driverId}, Transporter ID: ${userState.transporterId}");
      // Proceed to fetch routes
      _updateRoutes(routesRepository, userState);
    } else {
      print("User is not logged in.");
      setState(() {
        errorMessage = "User not logged in.";
        isLoading = false; // Stop loading
      });
    }

    _userListener = userCubit.stream.listen((state) {
      if (state is UserLoggedIn) {
        print(
            "User logged: Driver ID: ${state.driverId}, Transporter ID: ${state.transporterId}");
        _updateRoutes(routesRepository, state);
      }
    });

    updatePickups();
  }

  Future<void> _updateRoutes(
      IRoutesRepository routesRepository, UserLoggedIn state) async {
    await _routeListener?.cancel();
    _routeListener = null;

    final stream = routesRepository.getRoutes(state.driverId);
    setState(() {
      isLoading = true; // Set loading to true while fetching routes
    });

    _routeListener = stream.listen((routes) {
      setState(() {
        // Assuming that the first route is the selected one
        selectedRoute = routes.isNotEmpty ? routes.first : null;
        isLoading = false; // Loading is done when routes are fetched
      });
    });
  }

  // void updatePickups() async {
  //   print("updatePickups called in PickupsPage");
  //   final userCubit = context.read<IUserCubit>();

  //   setState(() {
  //     isLoading = true;
  //     errorMessage = "";
  //   });

  //   if (userCubit.state is UserLoggedIn || selectedRoute != null) {
  //     try {
  //       final pickupRepository =
  //           Provider.of<IPickupRepository>(context, listen: false);
  //       pickups = await pickupRepository.getPickups();
  //       print("Fetched pickups: $pickups");
  //     } catch (error) {
  //       print("Error loading pickups: ${error.toString()}");
  //       errorMessage = "Error loading pickups: ${error.toString()}";
  //     }
  //   } else {
  //     errorMessage = "User not logged in or routes not loaded.";
  //   }

  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  void updatePickups() async {
    print("updatePickups called in PickupsPage");
    final userCubit = context.read<IUserCubit>();

    setState(() {
      isLoading = true;
      errorMessage = "";
    });

    // Check if user is logged in
    if (userCubit.state is UserLoggedIn) {
      try {
        final pickupRepository = context.read<IPickupRepository>();
        pickups = await pickupRepository.getPickups();
        print("Fetched pickups: $pickups");
      } catch (error) {
        // Handle specific Firestore permission-denied error
        if (error.toString().contains('permission-denied')) {
          print(
              "Permission denied error: User does not have permission to access pickups.");
          errorMessage = "You do not have permission to access pickups.";
        } else {
          print("Error loading pickups: ${error.toString()}");
          errorMessage = "Error loading pickups: ${error.toString()}";
        }
      }
    } else {
      // Reject with an error if the user is not logged in
      print("User not logged in, rejecting pickup update.");
      errorMessage = "User not logged in. Please log in to access pickups.";
    }

    setState(() {
      isLoading = false;
    });
  }

  Widget loadingIndicator() {
    return Center(child: CircularProgressIndicator());
  }

  Widget errorWidget() {
    return Center(child: Text(errorMessage));
  }

  Widget pickupsList() {
    if (pickups.isEmpty) {
      return Center(
          child: Text(
              DccLocalizations.of(context)!.translate("pickupsListNoPickups")));
    }

    Map<String, List<Pickup>> customerId2pickups =
        HashMap<String, List<Pickup>>();
    Map<String, Customer> customerId2customer = HashMap<String, Customer>();

    for (Pickup pickup in pickups) {
      String customerId = pickup.originCustomer!.id;
      customerId2customer[customerId] = pickup.originCustomer!;
      customerId2pickups[customerId] ??= [];
      customerId2pickups[customerId]!.add(pickup);
    }

    List<String> customerIds = customerId2customer.keys.toList();

    return ListView.builder(
      itemCount: customerIds.length,
      padding: EdgeInsets.all(8.0),
      itemBuilder: (BuildContext context, int index) {
        String customerId = customerIds[index];
        return PickupGroup(
            customerId2customer[customerId]!, customerId2pickups[customerId]!);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 1),
      child: Scaffold(
        body: Padding(
          padding: widget.padding,
          child: isLoading
              ? loadingIndicator()
              : errorMessage.isNotEmpty
                  ? errorWidget()
                  : pickupsList(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _userListener?.cancel();
    _routeListener?.cancel();
    super.dispose();
  }
}


// import 'package:dcc/cubits/pickups_cubit.dart';
// import 'package:dcc/cubits/routes_cubit.dart';
// import 'package:dcc/cubits/states/pickups_state.dart';
// import 'package:dcc/cubits/states/routes_state.dart';
// import 'package:dcc/localization/app_localizations.dart';
// import 'package:dcc/widgets/bloc_sub_state/bloc_sub_state_builder.dart';
// import 'package:dcc/widgets/nav_fragment.dart';
// import 'package:dcc/widgets/pickups/add_pickup_fab.dart';
// import 'package:dcc/widgets/pickups/pickups_list.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class PickupsPage extends StatelessWidget implements NavFragment {
//   final EdgeInsets padding;

//   @override
//   final bool fullPage = false;

//   PickupsPage({this.padding = EdgeInsets.zero});

//   @override
//   Widget build(BuildContext context) {
//     final routesCubit = Provider.of<RoutesCubit>(context);
//     final localizations = DccLocalizations.of(context);

//     Widget loading() {
//       if (routesCubit.hasAnyRoutesAssigned()) {
//         return Center(child: CircularProgressIndicator());
//       }
//       if (routesCubit.state is RoutesLoaded) {
//         return Center(child: Text(""));
//       }
//       return Center(child: Text(localizations!.translate("pickupPagesAwaitingRoutes")));
//     }

//     Widget pickups() {
//       return BlocSubStateBuilder<PickupsCubit, PickupsState, PickupsLoaded>(
//         subStateBuilder: (context, state) => PickupsList(state.pickups),
//         fallbackBuilder: (context, state) => loading(),
//       );
//     }

//     return Padding(
//       padding: EdgeInsets.only(top: 1),
//       child: Scaffold(
//         floatingActionButton: AddPickupFab(),
//         body: Padding(
//           padding: padding,
//           child: pickups(),
//         ),
//       ),
//     );
//   }
// }
