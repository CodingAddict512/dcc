// import 'dart:async';
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class DccLocalizations {
//   final Locale locale;

//   DccLocalizations(this.locale);

//   static DccLocalizations of(BuildContext context) {
//     return Localizations.of<DccLocalizations>(context, DccLocalizations);
//   }

//   static const LocalizationsDelegate<DccLocalizations> delegate =
//       _AppLocalizationsDelegate();

//   static const List<Locale> supportedLocales = <Locale>[
//     Locale('en', 'US'),
//     Locale('da', 'DK'),
//   ];

//   Map<String, String> _localizedStrings;

//   Future<bool> load() async {
//     String jsonString = await rootBundle
//         .loadString('assets/localization/${locale.languageCode}.json');
//     Map<String, dynamic> jsonMap = json.decode(jsonString);

//     _localizedStrings = jsonMap.map((key, value) {
//       return MapEntry(key, value.toString());
//     });

//     return true;
//   }

//   // This method will be called from every widgets which needs a localized text
//   String translate(String key) {
//     return _localizedStrings[key] ?? key;
//   }
// }

// class _AppLocalizationsDelegate
//     extends LocalizationsDelegate<DccLocalizations> {
//   const _AppLocalizationsDelegate();

//   @override
//   bool isSupported(Locale locale) {
//     return DccLocalizations.supportedLocales
//         .map((l) => l.languageCode)
//         .contains(locale.languageCode);
//   }

//   @override
//   Future<DccLocalizations> load(Locale locale) async {
//     DccLocalizations localizations = new DccLocalizations(locale);
//     await localizations.load();
//     return localizations;
//   }

//   @override
//   bool shouldReload(_AppLocalizationsDelegate old) => false;
// }

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DccLocalizations {
  final Locale locale;

  DccLocalizations(this.locale);

  static DccLocalizations? of(BuildContext context) {
    return Localizations.of<DccLocalizations>(context, DccLocalizations);
  }

  static const LocalizationsDelegate<DccLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = <Locale>[
    Locale('en', 'US'),
    Locale('da', 'DK'),
  ];

  late Map<String, String> _localizedStrings;

  Future<bool> load() async {
    String jsonString = await rootBundle
        .loadString('assets/localization/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  // This method will be called from every widget which needs a localized text
  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<DccLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return DccLocalizations.supportedLocales
        .map((l) => l.languageCode)
        .contains(locale.languageCode);
  }

  @override
  Future<DccLocalizations> load(Locale locale) async {
    DccLocalizations localizations = DccLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
