import 'package:dcc/cubits/pickups_cubit.dart';
import 'package:dcc/cubits/states/pickups_state.dart';
import 'package:dcc/models/pickup.dart';
import 'package:dcc/widgets/bloc_sub_state/bloc_sub_state_builder.dart';
import 'package:dcc/widgets/pickup_details/details_buttons.dart';
import 'package:dcc/widgets/pickup_details/details_finish_button.dart';
import 'package:dcc/widgets/pickup_details/details_info.dart';
import 'package:dcc/widgets/pickup_details/edit_button.dart';
import 'package:flutter/material.dart';
import 'package:dcc/extensions/compat.dart';
import 'package:provider/provider.dart' show StreamProvider;

class PickupDetails extends StatelessWidget {
  Widget loading() => Center(child: CircularProgressIndicator());

  @override
  Widget build(BuildContext context) {
    final pickupsCubit = context.watch<PickupsCubit>();
    final pickupStream = pickupsCubit.stream
        .where((state) => state is PickupsLoaded)
        .map((state) => (state as PickupsLoaded).pickup);
    final navigator = Navigator.of(context);

    Widget onLoaded(PickupsLoaded state) {
      return StreamProvider<Pickup>(
        create: (context) => pickupStream,
        initialData: state.pickup,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                navigator.pop();
              },
            ),
            actions: [
              EditButton(),
            ],
          ),
          body: ListView(
            children: [
              DetailsInfo(),
              DetailsButtons(),
            ],
          ),
          bottomNavigationBar: DetailsFinishButton(),
        ),
      );
    }

    return BlocSubStateBuilder<PickupsCubit, PickupsState, PickupsLoaded>(
      subStateBuilder: (context, state) => onLoaded(state),
      fallbackBuilder: (context, state) => loading(),
    );
  }
}
