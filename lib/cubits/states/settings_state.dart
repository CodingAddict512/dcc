// import 'package:dcc/cubits/states/base_state.dart';
// import 'package:flutter/material.dart';
// import 'package:freezed_annotation/freezed_annotation.dart';

// part 'settings_state.freezed.dart';

// @immutable
// abstract class SettingsState extends BaseState {
//   const SettingsState();
// }

// @freezed
// abstract class SettingsInitial extends SettingsState with _$SettingsInitial {
//   SettingsInitial._();

//   factory SettingsInitial() = _SettingsInitial;
// }

// @freezed
// abstract class SettingsLoading extends SettingsState with _$SettingsLoading {
//   SettingsLoading._();

//   factory SettingsLoading() = _SettingsLoading;
// }

// @freezed
// abstract class SettingsLoaded extends SettingsState with _$SettingsLoaded {
//   SettingsLoaded._();

//   factory SettingsLoaded({
//     final String languageCode,
//     final ThemeMode themeMode,
//   }) = _SettingsLoaded;
// }

// @freezed
// abstract class SettingsError extends SettingsState with _$SettingsError {
//   SettingsError._();

//   factory SettingsError({
//     final String message,
//   }) = _SettingsError;
// }

import 'package:dcc/cubits/states/base_state.dart';
import 'package:flutter/material.dart';

class SettingsState extends BaseState {
  const SettingsState();
}

class SettingsInitial extends SettingsState {
  const SettingsInitial();
}

class SettingsLoading extends SettingsState {
  const SettingsLoading();
}

class SettingsLoaded extends SettingsState {
  final String languageCode;
  final ThemeMode themeMode;

  const SettingsLoaded({
    required this.languageCode,
    required this.themeMode,
  });
}

class SettingsError extends SettingsState {
  final String message;

  const SettingsError({
    required this.message,
  });
}
