import "package:flutter/material.dart";
import '../../../services/settings.dart' as settings;
import 'package:country_flags/country_flags.dart';

Widget buildLanguageSettings(BuildContext context) {
  final currentLang = settings.prefs?.getString('language') ?? 'de';

  // 1. Hier definierst du alle Sprachen: 'Sprachcode': 'Anzeigename'
  final Map<String, String> languages = {
    'de': 'Deutsch',
    'en': 'English',
    'fr': 'Français', // Einfach hier neue Sprachen hinzufügen...
    'es': 'Español',
  };

  return Padding(
    padding: const EdgeInsets.all(24),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sprache / Language',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        
        // 2. Hier loopen wir durch die Map und erstellen die ListTiles dynamisch
        ...languages.entries.map((entry) {
          final String langCode = entry.key;
          final String langName = entry.value;

          return ListTile(
            leading: CountryFlag.fromLanguageCode(
              langCode, 
              theme: const ImageTheme(height: 24, width: 36, shape: RoundedRectangle(4)),
            ),
            title: Text(langName),
            trailing: currentLang == langCode
                ? const Icon(Icons.check, color: Colors.green)
                : null,
            onTap: () {
              final s = settings.SettingsService();
              s.updateLanguage(langCode);
              Navigator.pop(context);
            },
          );
        }), // `.toList()` ist dank des Spread-Operators (...) im Column nicht zwingend nötig
      ],
    ),
  );
}