import 'package:dcc/cubits/final_disposition_cubit.dart';
import 'package:dcc/cubits/pickup_edit_cubit.dart';
import 'package:dcc/cubits/states/final_disposition_state.dart';
import 'package:dcc/cubits/states/pickup_edit_state.dart';
import 'package:dcc/localization/app_localizations.dart';
import 'package:dcc/models/final_disposition.dart';
import 'package:dcc/pages/type_search.dart';
import 'package:dcc/widgets/bloc_sub_state/bloc_sub_state_builder.dart';
import 'package:flutter/material.dart';
import 'package:dcc/extensions/compat.dart';

class TypeSelection extends StatelessWidget {
  final bool enabled;

  TypeSelection({
    this.enabled = true,
  });

  Widget loading() => CircularProgressIndicator();

  @override
  Widget build(BuildContext context) {
    final finalDispositionEditCubit = context.watch<FinalDispositionCubit>();
    final pickupEditCubit = context.watch<PickupEditCubit>();
    final origPickup = pickupEditCubit.state.ifState<PickupEditLoaded>(withState: (s) => s.oldPickup);
    final navigator = Navigator.of(context);
    final localizations = DccLocalizations.of(context);

    Widget title() {
      return BlocSubStateBuilder<FinalDispositionCubit, FinalDispositionState, FinalDispositionStateLoaded>(
        subStateBuilder: (context, state) {
          final dispositions = state.dispositions;
          if (dispositions?.isNotEmpty ?? false) {
            FinalDisposition finalDisposition = state.selectedFinalDisposition;
            if (finalDisposition == null && origPickup?.finalDispositionId != null) {
              finalDisposition = dispositions.firstWhere((element) => element.id == origPickup.finalDispositionId);
            }
            if (finalDisposition == null) {
              finalDisposition = dispositions.first;
            }
            return Text(finalDisposition.type);
          } else {
            return Text(localizations.translate("typeSelectionDispositionsNotAvailable"));
          }
        },
        fallbackBuilder: (context, state) => loading(),
      );
    }

    return InkWell(
      onTap: enabled
          ? () async {
              final result = await navigator.push(
                MaterialPageRoute(builder: (BuildContext context) {
                  return TypeSearch();
                }),
              );

              if (result != null && result is FinalDisposition) {
                finalDispositionEditCubit.selectFinalDisposition(result);
                pickupEditCubit.selectFinalDispositionType(result);
              }
            }
          : null,
      child: ListTile(
        leading: Icon(Icons.category),
        title: title(),
      ),
    );
  }
}
