import 'package:dcc/cubits/pickup_edit_cubit.dart';
import 'package:dcc/cubits/routes_cubit.dart';
import 'package:dcc/cubits/states/pickup_edit_state.dart';
import 'package:dcc/cubits/states/routes_state.dart';
import 'package:dcc/localization/app_localizations.dart';
// import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:dcc/extensions/compat.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SavePickupButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController noteController;

  SavePickupButton({required this.formKey, required this.noteController});

  @override
  Widget build(BuildContext context) {
    final pickupEditCubit = context.watch<PickupEditCubit>();
    final routesCubit = context.watch<RoutesCubit>();
    final localizations = DccLocalizations.of(context);
    final navigator = Navigator.of(context);

    void showL10nErrorMessage(String message) {
      // FlushbarHelper.createError(
      //   message: localizations.translate(message),
      //   duration: Duration(seconds: 3),
      // ).show(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations!.translate(message)),
          duration: Duration(seconds: 3),
        ),
      );
    }

    return ElevatedButton(
      onPressed: () {
        if (formKey.currentState!.validate()) {
          // Add text of note field to pickup edit
          pickupEditCubit.newNote(noteController.text);

          final pickup = pickupEditCubit.state.ifState<PickupEditLoaded>(
            withState: (s) => pickupEditCubit.editedPickup(s),
            orElse: (s) => null,
          );
          final route = routesCubit.state.ifState<RoutesLoaded>(
            withState: (s) => s.route,
            orElse: (s) => null,
          );
          if (route == null) {
            showL10nErrorMessage("pickupEditInternalErrorNoRoute");
            return;
          }
          if (pickup == null) {
            showL10nErrorMessage("pickupEditInternalErrorNoPickup");
            return;
          }
          if (pickup.originLocation == null) {
            showL10nErrorMessage("pickupEditMissingFromLocation");
            return;
          }
          if (pickup.receiverLocation == null) {
            showL10nErrorMessage("pickupEditMissingToLocation");
            return;
          }
          if (pickup.finalDispositionId == null) {
            showL10nErrorMessage("pickupEditMissingFinalDisposition");
            return;
          }

          if (pickup.metricTypeId == null) {
            showL10nErrorMessage("pickupEditMissingMetric");
            return;
          }
          pickupEditCubit.save().then((_) => navigator.pop(true));
        }
      },
      child: Text(localizations!.translate("pickupDetailsSaveTxt")),
    );
  }
}
