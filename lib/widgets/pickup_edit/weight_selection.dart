import 'package:dcc/cubits/pickup_edit_cubit.dart';
import 'package:dcc/cubits/states/pickup_edit_state.dart';
import 'package:dcc/widgets/flexible_weight_info.dart';
import 'package:dcc/widgets/register_weight.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeightSelection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PickupEditCubit, PickupEditState>(
      builder: (context, state) {
        return state.ifState<PickupEditLoaded>(
          withState: (state) {
            void onWeightPress() async {
              final result = await showDialog(
                context: context,
                builder: (context) => RegisterWeight(
                  amount: state.amount,
                  metric: state.metric!,
                  actualAmount: state.actualAmount,
                  actualMetric: state.actualMetric!,
                  weight: state.weight,
                ),
              );
              if (result is AmountMetricWeight) {
                context.watch<PickupEditCubit>().registerWeight(
                    result.amount, result.metric, result.weight);
              }
            }

            return InkWell(
              onTap: onWeightPress,
              child: ListTile(
                leading: Icon(Icons.storage),
                title: FlexibleWeightInfo(
                  weight: "",
                  amount: state.amount,
                  metric: state.metric?.metric ?? 0,
                  actualAmount: state.actualAmount,
                  actualMetric: state.actualMetric?.metric ?? 0,
                ),
              ),
            );
          },
          orElse: (state) => CircularProgressIndicator(),
        );
      },
    );
  }
}
