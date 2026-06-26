import 'package:flutter/material.dart';
import 'package:country_flags/country_flags.dart';
import 'settings/widgets/language.dart';
import 'settings/widgets/accent.dart';
import '../services/settings.dart';
import '../widgets/slider_list_tile.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: SettingsService(),
      builder: (context, _) {
        final s = SettingsService();
        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(title: const Text('Settings')),
          body: ListView(
            padding: EdgeInsets.only(
              top: 0,
              bottom: MediaQuery.of(context).padding.bottom + s.gradientHeight,
            ),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 2,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FloatingActionButton.extended(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => buildLanguageSettings(context),
                      );
                    },
                    label: const Text("Language"),
                    icon: CountryFlag.fromLanguageCode(
                      s.language,
                      theme: const ImageTheme(
                        height: 24,
                        width: 36,
                        shape: RoundedRectangle(4),
                      ),
                    ),
                  ),
                ),
              ),
              Divider(
                height: 20,
                thickness: 5,
                indent: 20,
                endIndent: 20,
                color: s.accentColor.withValues(alpha: 0.2),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Text(
                  'Appearance',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: s.accentColor,
                  ),
                ),
              ),
              SwitchListTile(
                title: const Text('Dark Mode'),
                value: s.themeMode == ThemeMode.dark,
                onChanged: (value) {
                  s.updateThemeMode(value);
                  if (!value) {
                    s.updatePitchBlack(false);
                  }
                },
              ),

              if (s.themeMode == ThemeMode.dark)
                SwitchListTile(
                  title: const Text('Pitch Black'),
                  subtitle: const Text('True black für AMOLED'),
                  value: s.pitchBlack,
                  onChanged: (value) {
                    s.updatePitchBlack(value);
                  },
                ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 2,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FloatingActionButton.extended(
                    heroTag: 'accent',
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => buildAccentColorPicker(context),
                      );
                    },
                    label: const Text('Akzentfarbe'),
                    icon: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: s.accentColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
              Divider(
                height: 10,
                thickness: 2,
                indent: 20,
                endIndent: 20,
                color: s.accentColor.withValues(alpha: 0.2),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 2,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FloatingActionButton.extended(
                    heroTag: 'systemDefaults',
                    onPressed: () {
                      s.updateAccentColor(s.systemAccentColor);
                      s.updateThemeMode(
                        WidgetsBinding
                                .instance
                                .platformDispatcher
                                .platformBrightness ==
                            Brightness.dark,
                      );
                    },
                    label: const Text('Use System Defaults'),
                    icon: const Icon(Icons.refresh),
                  ),
                ),
              ),
              SliderListTile(
                title: const Text('Background Blur'),
                subtitle: Text('${s.bgblur.toInt()} px'),
                value: s.bgblur,
                min: 0,
                max: 20,
                onChanged: (value) {
                  s.updateBgBlur(value);
                },
              ),
              Divider(
                height: 20,
                thickness: 5,
                indent: 20,
                endIndent: 20,
                color: s.accentColor.withValues(alpha: 0.2),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(
                      value: 'metric',
                      label: Text('Metrisch'),
                      icon: Icon(Icons.thermostat),
                    ),
                    ButtonSegment(
                      value: 'imperial',
                      label: Text('Imperial'),
                      icon: Icon(Icons.thunderstorm),
                    ),
                  ],
                  selected: {s.units},
                  onSelectionChanged: (newSelection) {
                    s.updateUnits(newSelection.first);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: AboutListTile(
                  icon: const Icon(Icons.info_outline),
                  applicationName: 'Simple Weather',
                  applicationVersion: '1.1.0+1',
                  applicationIcon: const Icon(Icons.wb_sunny_rounded, size: 48),
                  applicationLegalese: '© 2026 OseMine',
                  aboutBoxChildren: [
                    const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text(
                        'The Most Simple Weatherapp',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 2,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FloatingActionButton.extended(
                    heroTag: 'reset',
                    onPressed: () {
                      s.resetapp();
                    },
                    label: const Text('Reset app'),
                    icon: const Icon(Icons.restart_alt),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
