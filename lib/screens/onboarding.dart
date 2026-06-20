import 'package:flutter/material.dart';
import '../services/settings.dart';
import 'package:geolocator/geolocator.dart';

class OnboardingScreen extends StatefulWidget {
  final SettingsService settingsService;

  const OnboardingScreen({super.key, required this.settingsService});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _locationPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    final permission = await Geolocator.checkPermission();
    if (mounted) {
      setState(() {
        _locationPermissionGranted = permission == LocationPermission.whileInUse || permission == LocationPermission.always;
      });
    }
  }

  static const _totalSteps = 5;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildCard({required List<Widget> children}) {
    final colors = Theme.of(context).colorScheme;
    return Center(
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: colors.surfaceContainerHighest.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: colors.outlineVariant.withValues(alpha: 0.25),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.settingsService,
      builder: (context, child) {
        final theme = Theme.of(context);
        final colors = theme.colorScheme;

        return Scaffold(
          backgroundColor: colors.surface,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
                  child: LinearProgressIndicator(
                    value: (_currentPage + 1) / _totalSteps,
                    borderRadius: BorderRadius.circular(999),
                    backgroundColor: colors.surfaceContainerHighest.withValues(
                      alpha: 0.4,
                    ),
                    color: widget.settingsService.accentColor,
                    minHeight: 6,
                  ),
                ),

                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                      if (index == _totalSteps - 1) {
                        _checkLocationPermission();
                      }
                    },
                    children: [
                      _buildWelcomePage(),
                      _buildThemeAndLanguagePage(theme),
                      _buildAccentColorPage(theme),
                      _buildUnitsPage(theme),
                      _buildLocationServicesPage(theme),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AnimatedOpacity(
                        opacity: _currentPage > 0 ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 200),
                        child: IgnorePointer(
                          ignoring: _currentPage == 0,
                          child: FloatingActionButton.extended(
                            heroTag: 'back',
                            onPressed: () {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeInOutCubic,
                              );
                            },
                            icon: const Icon(Icons.arrow_back_rounded),
                            label: const Text('Zurück'),
                            backgroundColor: colors.surfaceContainerHigh,
                            foregroundColor: colors.onSurface,
                          ),
                        ),
                      ),

                      FloatingActionButton.extended(
                        heroTag: 'next',
                        onPressed: _currentPage < _totalSteps - 1
                            ? () {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeInOutCubic,
                                );
                              }
                            : _locationPermissionGranted
                                ? () => widget.settingsService.completeOnboarding()
                                : null,
                        icon: Icon(
                          _currentPage == _totalSteps - 1
                              ? Icons.check
                              : Icons.arrow_forward_rounded,
                        ),
                        label: Text(
                          _currentPage == _totalSteps - 1
                              ? 'Starten'
                              : 'Weiter',
                        ),
                        backgroundColor: _currentPage == _totalSteps - 1 && !_locationPermissionGranted
                            ? colors.surfaceContainerHigh
                            : widget.settingsService.accentColor,
                        foregroundColor: _currentPage == _totalSteps - 1 && !_locationPermissionGranted
                            ? colors.onSurface.withValues(alpha: 0.4)
                            : Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWelcomePage() {
    final theme = Theme.of(context);
    return _buildCard(
      children: [
        Icon(
          Icons.wb_sunny_rounded,
          size: 72,
          color: widget.settingsService.accentColor,
        ),
        const SizedBox(height: 24),
        Text(
          'Simple Weather',
          style: theme.textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'Dein minimalistischer Wetterbegleiter. Lass uns die App kurz an dich anpassen.',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildThemeAndLanguagePage(ThemeData theme) {
    final service = widget.settingsService;
    return _buildCard(
      children: [
        Text(
          'Erscheinungsbild',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text('Sprache', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 8),
        SegmentedButton<String>(
          segments: const [
            ButtonSegment(
              value: 'de',
              label: Text('Deutsch'),
              icon: Icon(Icons.language),
            ),
            ButtonSegment(
              value: 'en',
              label: Text('English'),
              icon: Icon(Icons.language),
            ),
          ],
          selected: {service.language},
          onSelectionChanged: (newSelection) {
            service.updateLanguage(newSelection.first);
          },
        ),
        const SizedBox(height: 24),
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(16),
          ),
          child: SwitchListTile(
            secondary: Icon(
              service.themeMode == ThemeMode.dark
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            title: const Text('Dunkles Design'),
            value: service.themeMode == ThemeMode.dark,
            activeThumbColor: service.accentColor,
            onChanged: (isDark) => service.updateThemeMode(isDark),
          ),
        ),
      ],
    );
  }

  Widget _buildAccentColorPage(ThemeData theme) {
    final service = widget.settingsService;
    final List<Color> colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      service.systemAccentColor,
    ];

    return _buildCard(
      children: [
        Text(
          'Deine Akzentfarbe',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Färbe Knöpfe und Details nach deinem Geschmack.',
          style: theme.textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 14,
          runSpacing: 14,
          alignment: WrapAlignment.center,
          children: colors.map((color) {
            final isSelected = service.accentColor == color;
            return GestureDetector(
              onTap: () => service.updateAccentColor(color),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: isSelected
                      ? Border.all(color: Colors.white, width: 3)
                      : null,
                  boxShadow: isSelected
                      ? [BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 8, offset: const Offset(0, 2))]
                      : [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 4, offset: const Offset(0, 1))],
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white, size: 22)
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildUnitsPage(ThemeData theme) {
    final service = widget.settingsService;
    return _buildCard(
      children: [
        Text(
          'Einheitensystem',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Wie sollen Temperaturen angezeigt werden?',
          style: theme.textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        SegmentedButton<String>(
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
          selected: {service.units},
          onSelectionChanged: (newSelection) {
            service.updateUnits(newSelection.first);
          },
        ),
      ],
    );
  }

  Widget _buildLocationServicesPage(ThemeData theme) {
    return _buildCard(
      children: [
        Text(
          'Standortdienste',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Um das Wetter an deinem aktuellen Standort anzuzeigen, benötigt die App Zugriff auf deine Standortdaten. Du kannst dies später in den Einstellungen ändern.',
          style: theme.textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: FloatingActionButton.extended(
            heroTag: 'location',
            onPressed: () async {
              final permission = await Geolocator.requestPermission();
              if (mounted) {
                setState(() {
                  _locationPermissionGranted = permission == LocationPermission.whileInUse || permission == LocationPermission.always;
                });
              }
            },
            icon: Icon(
              _locationPermissionGranted ? Icons.check_circle : Icons.location_on,
            ),
            label: Text(
              _locationPermissionGranted ? 'Standortzugriff erteilt' : 'Standortzugriff erlauben',
            ),
            backgroundColor: _locationPermissionGranted
                ? Colors.green
                : widget.settingsService.accentColor,
            foregroundColor: Colors.white,
          ),
        ),
        if (!_locationPermissionGranted)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              'Du musst den Standortzugriff erlauben, um fortzufahren.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }
}
