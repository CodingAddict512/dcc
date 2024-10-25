import 'package:dcc/cubits/initialization_cubit.dart';
import 'package:dcc/cubits/user_cubit.dart';
import 'package:dcc/localization/app_localizations.dart';
import 'package:dcc/pages/initialization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = DccLocalizations.of(context);
    final navigator = Navigator.of(context);

    return IconButton(
      tooltip: localizations!.translate("settingsPageLogout"),
      icon: Icon(Icons.exit_to_app),
      onPressed: () async {
        await Provider.of<IUserCubit>(context).clearLoginCacheAndReset();
        Provider.of<InitializationCubit>(context).reset();
        navigator.pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => InitializationPage()),
          (route) => false,
        );
      },
    );
  }
}
