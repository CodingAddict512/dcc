import 'package:dcc/cubits/states/settings_state.dart';
import 'package:dcc/data/repositories/shared_preferences_repository_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final ISharedPreferencesRepository sharedPreferencesRepository;

  SettingsCubit({
    @required this.sharedPreferencesRepository,
  }) : super(SettingsInitial());


  factory SettingsCubit.fromContext(BuildContext context) => SettingsCubit(
    sharedPreferencesRepository: context.read<ISharedPreferencesRepository>(),
  );


  Future<void> loadSettings() async {
    emit(SettingsLoading());

    final loaded = SettingsLoaded(
      languageCode: await sharedPreferencesRepository.getLanguageCode(),
      themeMode: await sharedPreferencesRepository.getThemeMode(),
    );
    emit(loaded);
  }

  Future<void> setLanguageCode(String languageCode) async {
    await sharedPreferencesRepository.setLanguageCode(languageCode);
    state.ifState<SettingsLoaded>(
      withState: (state) async {
        final newState = state.copyWith(languageCode: await sharedPreferencesRepository.getLanguageCode());
        emit(newState);
      },
    );
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    await sharedPreferencesRepository.setThemeMode(themeMode);
    await state.ifState<SettingsLoaded>(
      withState: (state) async {
        final newState = state.copyWith(themeMode: await sharedPreferencesRepository.getThemeMode());
        emit(newState);
      },
    );
  }
}
