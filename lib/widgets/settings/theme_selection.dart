import 'package:dcc/cubits/settings_cubit.dart';
import 'package:dcc/cubits/states/settings_state.dart';
import 'package:dcc/extensions/context_localization.dart';
import 'package:dcc/localization/app_localizations.dart';
import 'package:dcc/widgets/bloc_sub_state/bloc_sub_state_builder.dart';
import 'package:dcc/widgets/settings/theme_dialog.dart';
import 'package:flutter/material.dart';
import 'package:dcc/extensions/compat.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeSelection extends StatelessWidget {
  Widget loading() => Center(child: CircularProgressIndicator());

  @override
  Widget build(BuildContext context) {
    Widget currentSetting() {
      return BlocSubStateBuilder<SettingsCubit, SettingsState, SettingsLoaded>(
        subStateBuilder: (context, state) {
          return Text(context.themeModeToString(state.themeMode));
        },
        fallbackBuilder: (context, state) => loading(),
      );
    }

    return ListTile(
      onTap: () async {
        final result = await showDialog(
          context: context,
          builder: (context) => ThemeDialog(),
        );
        if (result is ThemeMode) {
          context.watch<SettingsCubit>().setThemeMode(result);
        }
      },
      leading: Icon(Icons.brightness_6),
      title: Text(DccLocalizations.of(context)!.translate("settingsPageTheme")),
      trailing: currentSetting(),
    );
  }
}
