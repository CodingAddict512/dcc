import 'package:dcc/cubits/cars_cubit.dart';
import 'package:dcc/cubits/routes_cubit.dart';
import 'package:dcc/cubits/states/cars_state.dart';
import 'package:dcc/cubits/states/user_state.dart';
import 'package:dcc/cubits/user_cubit.dart';
import 'package:dcc/data/firestore/firestore_helper.dart';
import 'package:dcc/data/firestore/firestore_path.dart';
import 'package:dcc/localization/app_localizations.dart';
import 'package:dcc/models/pickup_route.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:dcc/extensions/compat.dart';
import 'package:intl/intl.dart';

class SavePickupRouteButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final String routeId;

  SavePickupRouteButton({
    @required this.formKey,
    @required this.routeId,
  });

  @override
  Widget build(BuildContext context) {
    final carsCubit = context.watch<CarsCubit>();
    final routesCubit = context.watch<RoutesCubit>();
    final userCubit = context.watch<IUserCubit>();
    final localizations = DccLocalizations.of(context);
    final navigator = Navigator.of(context);

    void showL10nErrorMessage(String message) {
      FlushbarHelper.createError(
        message: localizations.translate(message),
        duration: Duration(seconds: 3)
      ).show(context);
    }

    return ElevatedButton(
      onPressed: () {
        if (formKey.currentState.validate()) {
          final selectedCar = carsCubit.state.ifState<CarsLoaded>(
            withState: (s) => s.selectedCar,
            orElse: null,
          );
          final driverId = userCubit.state.ifState<UserLoggedIn>(
            withState: (s) => s.driverId,
            orElse: null,
          );
          final transporterId = userCubit.state.ifState<UserLoggedIn>(
            withState: (s) => s.transporterId,
            orElse: null,
          );

          if (selectedCar == null) {
            showL10nErrorMessage("pickupRouteCreationErrorMissingCar");
            return;
          }
          if (driverId == null) {
            showL10nErrorMessage("pickupRouteCreationInternalErrorNoDriver");
            return;
          }

          final route = PickupRoute(
            id: routeId,
            name: "PENDING",  /* Notifies the backend that it should create the order */
            isActive: true,
            plannedDate: DateFormat("yyyy-MM-dd").format(DateTime.now()),
            assignedDriver: driverId,
            assignedOrders: [],
            draftOrders: [],
            car: FirestoreHelper.instance.doc(FirestorePath.car(transporterId, selectedCar.id))
          );

          routesCubit.addNewRoute(route).then((_) => navigator.pop(true));
        }
      },
      child:
          Text(localizations.translate("pickupRouteSaveTxt")),
    );
  }
}
