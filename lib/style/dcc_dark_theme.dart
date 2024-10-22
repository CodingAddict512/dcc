import 'package:dcc/style/dcc_font_family.dart';
import 'package:flutter/material.dart';

class DccDarkTheme {
  static final _darkPrimaryColor = Color(0xff1C73E8);
  static final _darkPrimaryColorLight = Color(0xff1a73e8);
  static final _darkPrimaryColorDark = Color(0xff002984);
  static final _darkAccentColor = _darkPrimaryColorLight;
  static final _darkBackgroundColor = Color(0xff0d0d0f);
  static final _darkBackgroundColorLight = Color(0xff1a1a1c);

  static final _darkColorScheme = ColorScheme(
    background: _darkBackgroundColor,
    primary: _darkPrimaryColor,
    primaryVariant: _darkPrimaryColorDark,
    secondary: Colors.white,
    secondaryVariant: Colors.grey,
    surface: _darkBackgroundColor,
    brightness: Brightness.dark,
    error: Colors.red,
    onBackground: Colors.white,
    onError: Colors.black,
    onSurface: Colors.white,
    onPrimary: Colors.white,
    onSecondary: _darkPrimaryColor,
  );

  static final _darkButtonTheme = ButtonThemeData(
    buttonColor: _darkPrimaryColor,
    textTheme: ButtonTextTheme.primary,
  );

  static final _darkAppBarTheme = AppBarTheme(
    elevation: 0,
    color: _darkBackgroundColor,
  );

  static final _darkPrimaryIconTheme = IconThemeData(
    color: Colors.grey,
  );

  static final _darkBottomNavigationBarTheme = BottomNavigationBarThemeData(
    backgroundColor: _darkBackgroundColorLight,
  );

  static final _darkFloatingActionButtonTheme = FloatingActionButtonThemeData(
    backgroundColor: _darkPrimaryColor,
  );

  static final themeData = ThemeData(
    scaffoldBackgroundColor: _darkBackgroundColor,
    primaryIconTheme: _darkPrimaryIconTheme,
    colorScheme: _darkColorScheme,
    primaryColor: _darkPrimaryColor,
    primaryColorLight: _darkPrimaryColorLight,
    primaryColorDark: _darkPrimaryColorDark,
    accentColor: _darkAccentColor,
    fontFamily: DccFontFamily.productSans,
    backgroundColor: _darkBackgroundColor,
    buttonTheme: _darkButtonTheme,
    appBarTheme: _darkAppBarTheme,
    bottomNavigationBarTheme: _darkBottomNavigationBarTheme,
    floatingActionButtonTheme: _darkFloatingActionButtonTheme,
  );
}
