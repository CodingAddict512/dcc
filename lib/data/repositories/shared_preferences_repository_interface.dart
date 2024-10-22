import 'package:dcc/models/firestore_configuration.dart';
import 'package:flutter/material.dart';

abstract class ISharedPreferencesRepository {
  /* Language code */
  Future<String> getLanguageCode();
  Future<void> setLanguageCode(String value);

  /* Theme mode */
  Future<ThemeMode> getThemeMode();
  Future<void> setThemeMode(ThemeMode themeMode);

  /* Recent Customer Ids */
  Future<List<String>> getRecentCustomerIds();
  Future<void> setRecentCustomerIds(List<String> value);

  /* Firestore configuration */
  Future<FirestoreConfiguration> getFirestoreConfiguration();
  Future<void> setFirestoreConfiguration(FirestoreConfiguration firestoreConfiguration);

  /* Clear */
  Future<void> clearAll();
}
