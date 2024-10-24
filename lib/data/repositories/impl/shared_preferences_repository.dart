import 'package:dcc/data/repositories/shared_preferences_repository_interface.dart';
import 'package:dcc/models/firestore_configuration.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesKeys {
  static const String language_code = "language_code";
  static const String theme_mode = "theme_mode";
  static const String recent_customer_ids = "recent_customer_ids";
  static const String firestore_configuration = "firestore_configuration";
}

class SharedPreferencesRepository extends ISharedPreferencesRepository {
  Future<SharedPreferences> get _sharedPreferences =>
      SharedPreferences.getInstance();

  /* Language code */
  Future<String> getLanguageCode() {
    return _sharedPreferences.then((prefs) =>
        prefs.getString(SharedPreferencesKeys.language_code) ?? 'en');
  }

  Future<void> setLanguageCode(String value) {
    return _sharedPreferences.then(
        (prefs) => prefs.setString(SharedPreferencesKeys.language_code, value));
  }

  // /* Theme mode */
  // Future<ThemeMode> getThemeMode() {
  //   return _sharedPreferences.then((prefs) {
  //     int themeModeIndex =
  //         prefs.getInt(SharedPreferencesKeys.theme_mode) as int;
  //     return ThemeMode.values[themeModeIndex];
  //   });
  // }
  Future<ThemeMode> getThemeMode() {
    return _sharedPreferences.then((prefs) {
      // Use a default value if theme_mode is not set in SharedPreferences
      int? themeModeIndex = prefs.getInt(SharedPreferencesKeys.theme_mode);

      // Check if the value is null, provide a default ThemeMode (e.g., ThemeMode.system)
      if (themeModeIndex == null) {
        return ThemeMode.system; // Or any default mode you want
      }

      return ThemeMode.values[themeModeIndex];
    });
  }

  Future<void> setThemeMode(ThemeMode themeMode) {
    return _sharedPreferences.then((prefs) {
      return prefs.setInt(SharedPreferencesKeys.theme_mode, themeMode.index);
    });
  }

  /* Recent Customer Ids */

  Future<List<String>> getRecentCustomerIds() {
    return _sharedPreferences.then((prefs) {
      return prefs.getStringList(SharedPreferencesKeys.recent_customer_ids) ??
          [];
    });
  }

  Future<void> setRecentCustomerIds(List<String> value) {
    return _sharedPreferences.then((prefs) {
      return prefs.setStringList(SharedPreferencesKeys.language_code, value);
    });
  }

  /* Firestore configuration */

  Future<FirestoreConfiguration> getFirestoreConfiguration() {
    return _sharedPreferences.then((prefs) {
      String value =
          prefs.getString(SharedPreferencesKeys.firestore_configuration) ?? '';
      try {
        return FirestoreConfiguration.fromPreferenceValue(value);
      } catch (e) {
        // return null;
        throw Exception('Failed to load Firestore configuration: $e');
      }
    });
  }

  Future<void> setFirestoreConfiguration(FirestoreConfiguration value) {
    return _sharedPreferences.then((prefs) {
      return prefs.setString(SharedPreferencesKeys.firestore_configuration,
          value.toPreferenceValue());
    });
  }

  /* Clear */

  Future<void> clearAll() {
    return _sharedPreferences.then((prefs) => prefs.clear());
  }
}
