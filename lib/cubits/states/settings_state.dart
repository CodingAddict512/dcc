import 'package:dcc/cubits/states/base_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta/meta.dart';

part 'settings_state.freezed.dart';

@immutable
abstract class SettingsState extends BaseState {
  const SettingsState();
}

@freezed
abstract class SettingsInitial extends SettingsState with _$SettingsInitial {
  SettingsInitial._();

  factory SettingsInitial() = _SettingsInitial;
}

@freezed
abstract class SettingsLoading extends SettingsState with _$SettingsLoading {
  SettingsLoading._();

  factory SettingsLoading() = _SettingsLoading;
}

@freezed
abstract class SettingsLoaded extends SettingsState with _$SettingsLoaded {
  SettingsLoaded._();

  factory SettingsLoaded({
    final String languageCode,
    final ThemeMode themeMode,
  }) = _SettingsLoaded;
}

@freezed
abstract class SettingsError extends SettingsState with _$SettingsError {
  SettingsError._();

  factory SettingsError({
    final String message,
  }) = _SettingsError;
}
