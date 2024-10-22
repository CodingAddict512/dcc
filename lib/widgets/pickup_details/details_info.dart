import 'package:dcc/localization/app_localizations.dart';
import 'package:dcc/models/pickup.dart';
import 'package:dcc/style/dcc_text_styles.dart';
import 'package:dcc/widgets/pickup_details/description_info.dart';
import 'package:dcc/widgets/pickup_details/details_customer.dart';
import 'package:dcc/widgets/pickup_details/details_customer_notes.dart';
import 'package:dcc/widgets/pickup_details/details_deadline.dart';
import 'package:dcc/widgets/pickup_details/details_status.dart';
import 'package:dcc/widgets/pickup_details/note_info.dart';
import 'package:dcc/widgets/pickup_details/weight_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailsInfo extends StatelessWidget {
  static const _dividerIndent = 8.0;

  @override
  Widget build(BuildContext context) {
    final pickup = Provider.of<Pickup>(context);
    if (pickup == null) {
      return Center(child: CircularProgressIndicator());
    }

    Widget finalDispositionText;
    if (pickup.actualFinalDispositionId != null &&
        pickup.finalDispositionId != pickup.actualFinalDispositionId) {
      finalDispositionText = Row(children: [
        Text(pickup.actualFinalDisposition),
        Divider(indent: _dividerIndent),
        Flexible(
          child: Text(
            pickup.finalDisposition,
            style: TextStyle(decoration: TextDecoration.lineThrough),
            overflow: TextOverflow.ellipsis,
          ),
        )
      ]);
    } else {
      finalDispositionText = Text(pickup.finalDisposition);
    }

    return Column(
      children: [
        ListTile(
          title: DetailsStatus(pickup.status),
          trailing: Text(
            pickup.id,
            style: DccTextStyles.pickupDetails.pickupId,
          ),
        ),
        DetailsDeadline(pickup.deadline),
        Divider(),
        Text(
          DccLocalizations.of(context).translate("pickupDetailsLabelFrom"),
          style: DccTextStyles.pickupEdit.toFrom,
        ),
        DetailsCustomer(pickup.originCustomer, pickup.originLocation),
        DetailsCustomerNotes(pickup.originCustomer),
        Text(
          DccLocalizations.of(context).translate("pickupDetailsLabelTo"),
          style: DccTextStyles.pickupEdit.toFrom,
        ),
        DetailsCustomer(pickup.receiverCustomer, pickup.receiverLocation),
        DetailsCustomerNotes(pickup.receiverCustomer),
        Divider(),
        ListTile(
          leading: Icon(Icons.category),
          title: finalDispositionText,
        ),
        WeightInfo(),
        DescriptionInfo(),
        NoteInfo(),
      ],
    );
  }
}
