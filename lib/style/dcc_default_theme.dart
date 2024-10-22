import 'package:dcc/style/dcc_font_family.dart';
import 'package:flutter/material.dart';

class DccLightTheme {
  static final _lightPrimaryColor = Color(0xff1C73E8);
  static final _lightPrimaryColorLight = Color(0xff1a73e8);
  static final _lightPrimaryColorDark = Color(0xff002984);
  static final _lightAccentColor = Colors.black;
  static final _lightBackgroundColor = Color(0xedeff1);

  static final _lightColorScheme = ColorScheme(
    background: _lightBackgroundColor,
    primary: _lightPrimaryColor,
    primaryVariant: _lightPrimaryColorDark,
    secondary: Colors.white,
    secondaryVariant: Colors.grey,
    surface: Colors.white,
    brightness: Brightness.light,
    error: Colors.red,
    onBackground: Colors.black,
    onError: Colors.white,
    onSurface: Colors.black,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
  );

  static final _lightPrimaryTextTheme = TextTheme(
    headline6: TextStyle(color: Colors.grey[700]),
  );

  static final _lightButtonTheme = ButtonThemeData(
    colorScheme: _lightColorScheme,
    buttonColor: _lightPrimaryColor,
    textTheme: ButtonTextTheme.primary,
  );

  static final _lightAppBarTheme = AppBarTheme(
    elevation: 0,
    color: _lightBackgroundColor,
  );

  static final _lightPrimaryIconTheme = IconThemeData(
    color: Colors.grey,
  );

  static final _lightAccentIconTheme = IconThemeData(
    color: Colors.white,
  );

  static final themeData = ThemeData(
    iconTheme: _lightPrimaryIconTheme,
    primaryIconTheme: _lightPrimaryIconTheme,
    accentIconTheme: _lightAccentIconTheme,
    colorScheme: _lightColorScheme,
    primaryColor: _lightPrimaryColor,
    primaryColorLight: _lightPrimaryColorLight,
    primaryColorDark: _lightPrimaryColorDark,
    primaryTextTheme: _lightPrimaryTextTheme,
    accentColor: _lightAccentColor,
    fontFamily: DccFontFamily.productSans,
    backgroundColor: _lightBackgroundColor,
    buttonTheme: _lightButtonTheme,
    appBarTheme: _lightAppBarTheme,
  );
}
