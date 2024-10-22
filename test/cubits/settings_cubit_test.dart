import 'package:bloc_test/bloc_test.dart';
import 'package:dcc/cubits/settings_cubit.dart';
import 'package:dcc/cubits/states/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/repositories/mock_shared_preferences_repository.dart';
import '../lib/test_repository.dart';

void main() {
  group('Settings Cubit', () {
    TestRepository initialTestRepository = TestRepository();

    blocTest(
      'initial state is correct',
      build: () => SettingsCubit(sharedPreferencesRepository: MockSharedPreferencesRepository()),
      expect: [],
    );

    blocTest(
      'load settings',
      build: () => SettingsCubit(sharedPreferencesRepository: MockSharedPreferencesRepository()),
      act: (SettingsCubit cubit) async {
        await cubit.loadSettings();
      },
      expect: [
        SettingsLoading(),
        SettingsLoaded(
          languageCode: initialTestRepository.languageCodeState,
          themeMode: initialTestRepository.themeModeState,
        ),
      ],
    );

    blocTest(
      'set language',
      build: () => SettingsCubit(sharedPreferencesRepository: MockSharedPreferencesRepository()),
      act: (SettingsCubit cubit) async {
        await cubit.loadSettings();
        await cubit.setLanguageCode('da');
      },
      expect: [
        SettingsLoading(),
        SettingsLoaded(
          languageCode: initialTestRepository.languageCodeState,
          themeMode: initialTestRepository.themeModeState,
        ),
        SettingsLoaded(
          languageCode: 'da',
          themeMode: initialTestRepository.themeModeState,
        ),
      ],
    );

    blocTest(
      'set theme',
      build: () => SettingsCubit(sharedPreferencesRepository: MockSharedPreferencesRepository()),
      act: (SettingsCubit cubit) async {
        await cubit.loadSettings();
        await cubit.setThemeMode(ThemeMode.dark);
        await cubit.setThemeMode(ThemeMode.light);
        await cubit.setThemeMode(ThemeMode.system);
      },
      expect: [
        SettingsLoading(),
        SettingsLoaded(
          languageCode: initialTestRepository.languageCodeState,
          themeMode: initialTestRepository.themeModeState,
        ),
        SettingsLoaded(
          languageCode: initialTestRepository.languageCodeState,
          themeMode: ThemeMode.dark,
        ),
        SettingsLoaded(
          languageCode: initialTestRepository.languageCodeState,
          themeMode: ThemeMode.light,
        ),
        SettingsLoaded(
          languageCode: initialTestRepository.languageCodeState,
          themeMode: ThemeMode.system,
        ),
      ],
    );
  });
}
