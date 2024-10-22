import 'package:dcc/cubits/settings_cubit.dart';
import 'package:dcc/cubits/states/settings_state.dart';
import 'package:dcc/localization/app_localizations.dart';
import 'package:dcc/pages/home.dart';
import 'package:dcc/pages/initialization.dart';
import 'package:dcc/pages/login.dart';
import 'package:dcc/style/dcc_themes.dart';
import 'package:dcc/widgets/bloc_sub_state/bloc_sub_state_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class DccApp extends StatelessWidget {
  Widget loading() => Center(child: CircularProgressIndicator());

  @override
  Widget build(BuildContext context) {
    return BlocSubStateBuilder<SettingsCubit, SettingsState, SettingsLoaded>(
      subStateBuilder: (context, state) {
        return MaterialApp(
          title: 'DCC APP',
          theme: DccThemes.lightTheme,
          darkTheme: DccThemes.darkTheme,
          themeMode: state.themeMode,
          locale: DccLocalizations.supportedLocales.firstWhere(
                  (l) => l.languageCode == state.languageCode,
                  orElse: () => DccLocalizations.supportedLocales.first
          ),
          supportedLocales: DccLocalizations.supportedLocales,
          localizationsDelegates: [
            DccLocalizations.delegate,
            //Built-in localization of basic text for Material widgets (means those default Material widget such as alert dialog icon text)
            GlobalMaterialLocalizations.delegate,
            //Built-in localization for text direction LTR/RTL
            GlobalWidgetsLocalizations.delegate,
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale?.languageCode || supportedLocale.countryCode == locale?.countryCode) {
                return supportedLocale;
              }
            }
            //if the locale from the mobile device is not supported yet,
            //user the first one from the list (in our case, that will be English)
            return supportedLocales.first;
          },
          initialRoute: '/initial',
          routes: {
            '/initial': (context) => InitializationPage(),
            '/login': (context) => LoginPage(),
            '/home': (context) => HomePage(),
          },
        );
      },
      fallbackBuilder: (context, state) => loading(),
    );
  }
}
