import 'package:dcc/cubits/customers_cubit.dart';
import 'package:dcc/cubits/final_disposition_cubit.dart';
import 'package:dcc/cubits/metric_type_cubit.dart';
import 'package:dcc/cubits/pickups_cubit.dart';
import 'package:dcc/cubits/routes_cubit.dart';
import 'package:dcc/cubits/states/customers_state.dart';
import 'package:dcc/cubits/states/final_disposition_state.dart';
import 'package:dcc/cubits/states/metric_type_state.dart';
import 'package:dcc/cubits/states/pickups_state.dart';
import 'package:dcc/cubits/states/routes_state.dart';
import 'package:dcc/cubits/states/user_state.dart';
import 'package:dcc/cubits/user_cubit.dart';
import 'package:dcc/extensions/status.dart';
import 'package:dcc/localization/app_localizations.dart';
import 'package:dcc/models/customer.dart';
import 'package:dcc/models/file_format.dart';
import 'package:dcc/models/final_disposition.dart';
import 'package:dcc/models/location.dart';
import 'package:dcc/models/metric_type.dart';
import 'package:dcc/models/pickup.dart';
import 'package:dcc/models/pickup_route.dart';
import 'package:dcc/models/status.dart';
import 'package:dcc/pages/pickup_edit.dart';
import 'package:dcc/pages/pickup_route_create.dart';
import 'package:dcc/style/dcc_text_styles.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:dcc/extensions/compat.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

class AddPickupFab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userCubit = context.watch<IUserCubit>();
    final metricTypeCubit = context.watch<MetricTypeCubit>();
    final finalDispositionCubit = context.watch<FinalDispositionCubit>();
    final routesCubit = context.watch<RoutesCubit>();
    final pickupCubit = context.watch<PickupsCubit>();
    final customersCubit = context.watch<CustomersCubit>();
    final localizations = DccLocalizations.of(context);

    bool showL10nErrorMessage(String message) {
      FlushbarHelper.createError(
        message: localizations.translate(message),
        duration: Duration(seconds: 3)
      ).show(context);
      return false;
    }

    Pickup placeholderPickup() {
      final id = Uuid(options: {
        'rng': UuidUtil.cryptoRNG // Use crypto RNG
      }).v4();
      String uid = userCubit.state.ifState<UserLoggedIn>(
          withState: (s) => s.driverId,
          orElse: (s) => null,
      );
      MetricType metricType = metricTypeCubit.state.ifState<MetricTypeStateLoaded>(
        withState: (s) => s.metricTypes.first,
        orElse: (s) => null,
      );
      FinalDisposition finalDisposition = finalDispositionCubit.state.ifState<FinalDispositionStateLoaded>(
        withState: (s) => s.selectedFinalDisposition ?? s.dispositions.first,
        orElse: (s) => null,
      );
      PickupRoute route = routesCubit.state.ifState<RoutesLoaded>(
        withState: (s) => s.route,
        orElse: (s) => null,
      );
      Customer defaultReceiver = customersCubit.state.ifState<CustomerStubsLoaded>(
        withState: (s) => s.defaultReceiver,
        orElse: (s) => null,
      );
      Location defaultReceiverLocation = defaultReceiver?.primaryLocation;
      return Pickup(
        id: id,
        orderId: "DRAFT", /* Ensures that the backend leaves it alone for now */
        route: route,
        amount: 1,
        metric: metricType?.metric,
        metricTypeId: metricType?.id,
        finalDisposition: finalDisposition?.type,
        finalDispositionId: finalDisposition?.id,
        actualAmount: 1,
        actualMetric: metricType?.metric,
        actualMetricTypeId: metricType?.id,
        actualFinalDisposition: finalDisposition?.type,
        actualFinalDispositionId: finalDisposition?.id,
        driverId: uid,
        deadline: DateFormat("yyyy-MM-dd").format(DateTime.now()),
        status: Status.DRAFT,
        originalStatus: Status.DRAFT,
        receiverCustomer: defaultReceiver,
        receiverLocation: defaultReceiverLocation,
        externalNHDocFormat: FileFormat.NONE,
      );
    }

    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme:
          IconThemeData(color: Theme.of(context).accentIconTheme.color),
      backgroundColor: Theme.of(context).primaryColor,
      overlayColor: Theme.of(context).backgroundColor,
      children: [
        SpeedDialChild(
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(
            Icons.local_shipping,
            color: Theme.of(context).accentIconTheme.color,
          ),
          label: localizations.translate("pickupFabCreatePickupLabel"),
          labelStyle: DccTextStyles.pickupFab.label,
          onTap: () async {
            if (!routesCubit.hasSelectedRoute()) {
              showL10nErrorMessage("pickupFabCreatePickupErrorSelectedRouteNotAvailable");
              return;
            }
            await Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) {
              return PickupEdit(placeholderPickup());
            }));
          },
        ),
        SpeedDialChild(
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(
            Icons.map,
            color: Theme.of(context).accentIconTheme.color,
          ),
          label: localizations.translate("pickupFabCreateRoute"),
          labelStyle: DccTextStyles.pickupFab.label,
          onTap: () async {
            await Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) {
              return PickupRouteCreate();
            }));
          },
        ),
        SpeedDialChild(
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(
            Icons.assignment_turned_in,
            color: Theme.of(context).accentIconTheme.color,
          ),
          label: localizations.translate("pickupFabCompleteRoute"),
          labelStyle: DccTextStyles.pickupFab.label,
          onTap: () async {
            bool allOk = routesCubit.state.ifState<RoutesLoaded>(
                withState: (s) => true,
                orElse: (s) => showL10nErrorMessage("pickupFabCompleteRouteErrorLoading"),
            ) && pickupCubit.state.ifState<PickupsLoaded>(
              withState: (s) {
                if (s.pickups.any((element) => element.status.isInProgress())) {
                  return showL10nErrorMessage("pickupFabCompleteRouteErrorPickupInProgress");
                }
                if (s.pickups.any((element) => element.status != Status.COLLECTED)) {
                  return showL10nErrorMessage("pickupFabCompleteRouteErrorAllMustBeCollected");
                }
                return true;
              },
              orElse: (s) => showL10nErrorMessage("pickupFabCompleteRouteErrorLoading"),
            );
            if (allOk) {
              routesCubit.state.ifState<RoutesLoaded>(
                withState: (s) => routesCubit.closeRoute(),
                orElse: (s) => showL10nErrorMessage("pickupFabCompleteRouteErrorLoading"),
              );
            }
          },
        ),
      ],
    );
  }
}
