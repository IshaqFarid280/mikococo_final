// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
//
// import 'messages_en.dart';
// import 'messages_es.dart';
//
// class AppLocalizations {
//   final Locale locale;
//
//   AppLocalizations(this.locale);
//
//   static Map<String, Map<String, String>> _localizedValues = {
//     'en': englishMessages, // Your English localization messages
//     'es': spanishMessages, // Your Spanish localization messages
//     // Add more languages as needed
//   };
//
//   String? translate(String key) {
//     final languageCode = _localizedValues[locale.languageCode];
//     if (languageCode != null) {
//       final hasKey = languageCode.containsKey(key);
//       return hasKey ? languageCode[key] : 'Localization key not found: $key';
//     }
//     return 'Localization key not found: $key';
//   }
//
//   static AppLocalizations? of(BuildContext context) {
//     return Localizations.of<AppLocalizations>(context, AppLocalizations);
//   }
//
//   static AppLocalizations? ofOrNull(BuildContext context) {
//     return Localizations.of<AppLocalizations>(context, AppLocalizations);
//   }
//
//   // Define a static property called delegate
//   static const delegate = AppLocalizationsDelegate();
// }
//
// class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
//   const AppLocalizationsDelegate();
//
//   @override
//   bool isSupported(Locale locale) {
//     // Include all supported locales here
//     return ['en', 'es'].contains(locale.languageCode);
//   }
//
//   @override
//   Future<AppLocalizations> load(Locale locale) async {
//     return AppLocalizations(locale);
//   }
//
//   @override
//   bool shouldReload(AppLocalizationsDelegate old) => false;
// }
