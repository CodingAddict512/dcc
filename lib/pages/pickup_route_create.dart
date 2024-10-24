import 'package:dcc/cubits/cars_cubit.dart';
import 'package:dcc/cubits/states/cars_state.dart';
import 'package:dcc/cubits/states/user_state.dart';
import 'package:dcc/cubits/user_cubit.dart';
import 'package:dcc/localization/app_localizations.dart';
import 'package:dcc/models/car.dart';
import 'package:dcc/style/dcc_text_styles.dart';
import 'package:dcc/widgets/bloc_sub_state/bloc_sub_state_builder.dart';
import 'package:dcc/widgets/pickup_edit/save_pickup_route_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
// import 'package:uuid/uuid_util.dart';

class PickupRouteCreate extends StatefulWidget {
  @override
  State createState() {
    return PickupRouteCreateState();
  }
}

class PickupRouteCreateState extends State {
  final _formKey = GlobalKey<FormState>();
  // DCC-737: We create the ID up front to avoid duplicates if the save
  // happens to be triggered multiple times.
  // final routeId = Uuid(options: {'rng': UuidUtil.cryptoRNG}).v4();
  // final uuid = Uuid();
  final routeId = Uuid().v4();

  PickupRouteCreateState();

  @override
  Widget build(BuildContext context) {
    final localizations = DccLocalizations.of(context);
    final carsCubit = Provider.of<CarsCubit>(context);
    final userCubit = Provider.of<IUserCubit>(context);
    final today = DateFormat("yyyy-MM-dd").format(DateTime.now());
    final navigator = Navigator.of(context);

    if (userCubit.state is UserLoggedIn &&
        !(carsCubit.state is CarsLoaded || carsCubit.state is CarsLoading)) {
      userCubit.state.ifState<UserLoggedIn>(
        withState: (s) => carsCubit.loadCars(s.transporterId),
        orElse: (state) {},
      );
    }

    Widget loading() {
      return Center(child: CircularProgressIndicator());
    }

    Widget _carDropDown(List<Car> allCars, Car selectedCar) {
      allCars.sort(
          (a, b) => (a.licensePlate ?? "").compareTo((b.licensePlate ?? "")));

      return DropdownButton<Car>(
          value: selectedCar,
          icon: Icon(Icons.arrow_drop_down),
          isExpanded: true,
          onChanged: (newCar) {
            carsCubit.selectCar(newCar!);
          },
          items: allCars
              .map((c) => DropdownMenuItem<Car>(
                    value: c,
                    child: Text(c.licensePlate),
                  ))
              .toList());
    }

    Widget _carSelectionTitle() {
      return BlocSubStateBuilder<CarsCubit, CarsState, CarsLoaded>(
        subStateBuilder: (context, state) {
          final allCars = state.allCars;
          if (allCars.isNotEmpty) {
            final selectedCar = state.selectedCar ?? allCars.first;
            return _carDropDown(allCars, selectedCar);
          }
          return Text(
              localizations!.translate("pickupRouteCreateErrorLoadingCars"));
        },
        fallbackBuilder: (context, state) => loading(),
      );
    }

    final title = Padding(
      padding: EdgeInsets.only(left: 16.0),
      child: Text(
        localizations!.translate("pickupRouteCreateTitle"),
        style: DccTextStyles.pickupRouteCreate.title,
      ),
    );

    final dateField = ListTile(
      leading: Icon(Icons.calendar_today),
      title: new Text(today),
    );

    final carDropDown = ListTile(
      leading: Icon(Icons.car_rental),
      title: _carSelectionTitle(),
    );

    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: TextButton(
            onPressed: () => navigator.pop(),
            child:
                Text(localizations.translate("pickupRouteCreateButtonDiscard")),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Row(
                children: [
                  SavePickupRouteButton(
                    formKey: _formKey,
                    routeId: routeId,
                  )
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
                  title,
                  dateField,
                  carDropDown,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
