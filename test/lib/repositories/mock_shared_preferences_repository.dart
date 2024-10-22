import 'package:dcc/data/repositories/shared_preferences_repository_interface.dart';
import 'package:dcc/models/firestore_configuration.dart';
import 'package:flutter/material.dart';

class MockSharedPreferencesRepository extends ISharedPreferencesRepository {
  String _languageCode;
  ThemeMode _themeMode;
  List<String> _recentCustomerIds;
  // We could have stored this as a FirestoreConfiguration, but this way we
  // also test serialization and deserialization.
  String _firestoreConfigurationSerialized;

  Future<String> getLanguageCode() async => _languageCode ?? 'en';
  Future<void> setLanguageCode(String value) async => _languageCode = value;

  /* Theme mode */
  Future<ThemeMode> getThemeMode() async => _themeMode ?? ThemeMode.system;
  Future<void> setThemeMode(ThemeMode themeMode) async => _themeMode = themeMode;

  /* Recent Customer Ids */
  Future<List<String>> getRecentCustomerIds() async => _recentCustomerIds;
  Future<void> setRecentCustomerIds(List<String> value) async => _recentCustomerIds = value;

  /* Firestore configuration */
  Future<FirestoreConfiguration> getFirestoreConfiguration() async {
    if (_firestoreConfigurationSerialized == null) {
      return null;
    }
    return FirestoreConfiguration.fromPreferenceValue(_firestoreConfigurationSerialized);
  }

  Future<void> setFirestoreConfiguration(FirestoreConfiguration firestoreConfiguration) async {
    _firestoreConfigurationSerialized = firestoreConfiguration.toPreferenceValue();
  }

  @override
  Future<void> clearAll() async {
    _languageCode = null;
    _themeMode = null;
    _recentCustomerIds = null;
    _firestoreConfigurationSerialized = null;
  }
}
