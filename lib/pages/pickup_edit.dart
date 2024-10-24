import 'package:dcc/cubits/final_disposition_cubit.dart';
import 'package:dcc/cubits/pickup_edit_cubit.dart';
import 'package:dcc/localization/app_localizations.dart';
import 'package:dcc/models/pickup.dart';
import 'package:dcc/models/status.dart';
import 'package:dcc/style/dcc_text_styles.dart';
import 'package:dcc/widgets/pickup_edit/note_edit.dart';
import 'package:dcc/widgets/pickup_edit/origin_customer_selection.dart';
import 'package:dcc/widgets/pickup_edit/origin_location_selection.dart';
import 'package:dcc/widgets/pickup_edit/receiver_customer_selection.dart';
import 'package:dcc/widgets/pickup_edit/receiver_location_selection.dart';
import 'package:dcc/widgets/pickup_edit/save_pickup_button.dart';
import 'package:dcc/widgets/pickup_edit/type_selection.dart';
import 'package:dcc/widgets/pickup_edit/weight_selection.dart';
import 'package:flutter/material.dart';
import 'package:dcc/extensions/compat.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PickupEdit extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _noteController = TextEditingController();
  final Pickup pickup;

  PickupEdit(this.pickup);

  @override
  Widget build(BuildContext context) {
    final localizations = DccLocalizations.of(context);
    final navigator = Navigator.of(context);
    final pickupEditCubit = context.watch<PickupEditCubit>();
    pickupEditCubit.load(pickup);

    final fromText = Padding(
      padding: EdgeInsets.only(left: 16.0),
      child: Text(
        localizations!.translate("pickupEditLabelFrom"),
        style: DccTextStyles.pickupEdit.toFrom,
      ),
    );

    final toText = Padding(
      padding: EdgeInsets.only(left: 16.0),
      child: Text(
        localizations.translate("pickupEditLabelTo"),
        style: DccTextStyles.pickupEdit.toFrom,
      ),
    );

    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: TextButton(
            onPressed: () {
              context
                  .watch<FinalDispositionCubit>()
                  .discardSelectedFinalDisposition();
              navigator.pop();
            },
            child: Text(localizations.translate("pickupEditButtonDiscard")),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Row(
                children: [
                  SavePickupButton(
                    formKey: _formKey,
                    noteController: _noteController,
                  ),
                ],
              ),
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Divider(),
                  TypeSelection(),
                  Divider(),
                  WeightSelection(),
                  Divider(),
                  fromText,
                  OriginCustomerSelection(
                    enabled: pickup.status == Status.DRAFT,
                  ),
                  OriginLocationSelection(),
                  Divider(),
                  toText,
                  ReceiverCustomerSelection(),
                  ReceiverLocationSelection(),
                  Divider(),
                  NoteEdit(
                    noteController: _noteController,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
