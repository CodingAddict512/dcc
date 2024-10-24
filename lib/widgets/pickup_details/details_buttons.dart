import 'package:dcc/cubits/metric_type_cubit.dart';
import 'package:dcc/cubits/pickups_cubit.dart';
import 'package:dcc/localization/app_localizations.dart';
import 'package:dcc/models/file_format.dart';
import 'package:dcc/models/pickup.dart';
import 'package:dcc/models/status.dart';
import 'package:dcc/pages/external_nh_doc.dart';
import 'package:dcc/pages/nh_doc.dart';
import 'package:dcc/pages/scan_nh_doc.dart';
import 'package:dcc/widgets/pickup_details/note_button.dart';
import 'package:dcc/widgets/register_weight.dart';
import 'package:flutter/material.dart';
import 'package:dcc/extensions/compat.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart' show Provider;

class DetailsButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pickup = Provider.of<Pickup>(context);
    final pickupsCubit = context.watch<PickupsCubit>();
    final metricTypeCubit = context.watch<MetricTypeCubit>();
    final localizations = DccLocalizations.of(context);
    final navigator = Navigator.of(context);

    void onWeightPress() async {
      final result = await showDialog(
        context: context,
        builder: (context) => RegisterWeight(
          amount: pickup.amount,
          metric: metricTypeCubit.metricTypeFromId(pickup.metricTypeId),
          actualAmount: pickup.actualAmount,
          actualMetric:
              metricTypeCubit.metricTypeFromId(pickup.actualMetricTypeId),
          weight: pickup.actualRegisteredWeight,
        ),
      );
      if (result is AmountMetricWeight) {
        pickupsCubit.registerWeight(
          result.amount,
          result.metric,
          result.weight,
        );
      }
    }

    Widget weightButton() {
      return ElevatedButton.icon(
        onPressed:
            pickup.status != Status.STARTED && pickup.status != Status.REJECTED
                ? null
                : onWeightPress,
        icon: Icon(Icons.edit),
        label:
            Text(localizations!.translate("pickupDetailsButtonRegisterWeight")),
      );
    }

    Widget showNhDocButton() {
      return ElevatedButton.icon(
        onPressed: () {
          navigator.push(
            MaterialPageRoute(
              builder: (context) => ExternalNhDocPage(),
            ),
          );
        },
        icon: Icon(Icons.photo),
        label:
            Text(localizations!.translate("pickupDetailsButtonShowNHDocument")),
      );
    }

    Widget generateNhDocButton() {
      return ElevatedButton.icon(
        onPressed: () {
          navigator.push(
            MaterialPageRoute(
              builder: (context) => NhDocPage(),
            ),
          );
        },
        icon: Icon(Icons.description),
        label: Text(
            localizations!.translate("pickupDetailsButtonGenerateNHDocument")),
      );
    }

    Widget scanNhDocButton() {
      return ElevatedButton.icon(
        onPressed: (pickup.status == Status.STARTED ||
                pickup.status == Status.REJECTED)
            ? () async {
                await navigator.push(MaterialPageRoute(
                  builder: (context) => ScanNhDocPage(),
                ));
              }
            : null,
        icon: Icon(Icons.photo_camera),
        label: Text(
            localizations!.translate("pickupDetailsButtonRegisterNHDocument")),
      );
    }

    List<Widget> nhdocButtons() {
      if (pickup.externalNHDocFormat == null ||
          pickup.externalNHDocFormat == FileFormat.NONE) {
        return [
          generateNhDocButton(),
          scanNhDocButton(),
        ];
      }
      return [
        showNhDocButton(),
      ];
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          onPressed:
              pickup.status != Status.ASSIGNED && pickup.status != Status.DRAFT
                  ? null
                  : () => pickupsCubit.startPickup(),
          icon: Icon(Icons.local_shipping),
          label: Text(
              localizations!.translate("pickupDetailsButtonRegisterPickup")),
        ),
        weightButton(),
        ...nhdocButtons(),
        NoteButton(),
      ],
    );
  }
}
