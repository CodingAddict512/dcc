import 'package:dcc/cubits/car_cubit.dart';
import 'package:dcc/cubits/cars_cubit.dart';
import 'package:dcc/cubits/customers_cubit.dart';
import 'package:dcc/cubits/external_nh_doc_cubit.dart';
import 'package:dcc/cubits/final_disposition_cubit.dart';
import 'package:dcc/cubits/geo_location_cubit.dart';
import 'package:dcc/cubits/initialization_cubit.dart';
import 'package:dcc/cubits/metric_type_cubit.dart';
import 'package:dcc/cubits/origin_locations_cubit.dart';
import 'package:dcc/cubits/pickup_edit_cubit.dart';
import 'package:dcc/cubits/pickups_cubit.dart';
import 'package:dcc/cubits/primary_locations_cubit.dart';
import 'package:dcc/cubits/receiver_locations_cubit.dart';
import 'package:dcc/cubits/routes_cubit.dart';
import 'package:dcc/cubits/settings_cubit.dart';
import 'package:dcc/cubits/transporter_cubit.dart';
import 'package:dcc/cubits/user_cubit.dart';
import 'package:dcc/cubits/version_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AbstractDependenciesProvider extends StatelessWidget {
  final Widget child;

  AbstractDependenciesProvider({@required this.child});

  IUserCubit getUserCubit(context);

  Widget repositories({child});

  @override
  Widget build(BuildContext context) {
    Widget blocs({child}) {
      return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => VersionCubit.fromContext(context)),
          BlocProvider(create: (context) {
            final settingsCubit = SettingsCubit.fromContext(context);
            settingsCubit.loadSettings();
            return settingsCubit;
          }),
          BlocProvider<IUserCubit>(create: (context) => getUserCubit(context)),
          BlocProvider(create: (context) => InitializationCubit.fromContext(context)),
          BlocProvider(create: (context) => FinalDispositionCubit.fromContext(context)),
          BlocProvider(create: (context) => MetricTypeCubit.fromContext(context)),
          BlocProvider(create: (context) => RoutesCubit.fromContext(context)),
          BlocProvider(create: (context) => CarCubit.fromContext(context)),
          BlocProvider(create: (context) => TransporterCubit.fromContext(context)),
          BlocProvider(create: (context) => CarsCubit.fromContext(context)),
          BlocProvider(create: (context) => PickupsCubit.fromContext(context)),
          BlocProvider(create: (context) => PickupEditCubit.fromContext(context)),
          BlocProvider(create: (context) => CustomersCubit.fromContext(context)),
          BlocProvider(create: (context) => OriginLocationsCubit.fromContext(context)),
          BlocProvider(create: (context) => ReceiverLocationsCubit.fromContext(context)),
          BlocProvider(create: (context) => GeoLocationCubit()),
          BlocProvider(create: (context) => PrimaryLocationsCubit.fromContext(context)),
          BlocProvider(create: (context) => ExternalNhDocCubit.fromContext(context)),
        ],
        child: child,
      );
    }

    return repositories(child: blocs(child: child));
  }
}
