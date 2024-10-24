import 'package:dcc/localization/app_localizations.dart';
import 'package:flutter/material.dart';

extension contextLocalization on BuildContext {
  String languageCodeToString(String languageCode) {
    switch (languageCode) {
      case "da":
        return DccLocalizations.of(this)!
            .translate("settingsPageLanguageCodeDa");
        break;
      case "en":
        return DccLocalizations.of(this)!
            .translate("settingsPageLanguageCodeEn");
        break;
      default:
        return DccLocalizations.of(this)!.translate("settingsPageUnknown");
    }
  }

  String themeModeToString(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.system:
        return DccLocalizations.of(this)!
            .translate("settingsPageThemeModeSystem");
        break;
      case ThemeMode.light:
        return DccLocalizations.of(this)!
            .translate("settingsPageThemeModeLight");
        break;
      case ThemeMode.dark:
        return DccLocalizations.of(this)!
            .translate("settingsPageThemeModeDark");
        break;
      default:
        return DccLocalizations.of(this)!.translate("settingsPageUnknown");
    }
  }
}
