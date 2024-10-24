import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesKeys {
  static const String language_code = "language_code";
  static const String theme_mode = "theme_mode";
  static const String recent_customer_ids = "recent_customer_ids";
}

class SharedPreferencesService {
  /* Language code */
  static Future<String> getLanguageCode() {
    return SharedPreferences.getInstance().then((prefs) {
      return prefs.getString(SharedPreferencesKeys.language_code) ?? 'en';
    });
  }

  static Future<void> setLanguage(String value) {
    return SharedPreferences.getInstance().then((prefs) {
      return prefs.setString(SharedPreferencesKeys.language_code, value);
    });
  }

  /* Theme mode */
  static Future<ThemeMode> getThemeMode() {
    return SharedPreferences.getInstance().then((prefs) {
      int themeModeIndex = prefs.getInt(SharedPreferencesKeys.theme_mode)!;
      return ThemeMode.values[themeModeIndex];
    });
  }

  static Future<void> setThemeMode(ThemeMode themeMode) {
    return SharedPreferences.getInstance().then((prefs) {
      return prefs.setInt(SharedPreferencesKeys.theme_mode, themeMode.index);
    });
  }

  /* Recent Customer Ids */

  static Future<List<String>> getRecentCustomerIds() {
    return SharedPreferences.getInstance().then((prefs) {
      return prefs.getStringList(SharedPreferencesKeys.recent_customer_ids) ??
          [];
    });
  }

  static Future<void> setRecentCustomerIds(List<String> value) {
    return SharedPreferences.getInstance().then((prefs) {
      return prefs.setStringList(SharedPreferencesKeys.language_code, value);
    });
  }
}
