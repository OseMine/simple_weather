import 'package:flutter/material.dart';
import '../services/settings.dart';

class OnboardingScreen extends StatefulWidget {
  final SettingsService settingsService;

  const OnboardingScreen({super.key, required this.settingsService});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const _totalSteps = 4;

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
            color: colors.surfaceContainerHigh.withValues(alpha: 0.93),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: colors.outlineVariant.withValues(alpha: 0.35),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 24,
                offset: const Offset(0, 8),
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
                    backgroundColor: colors.surfaceContainerHighest.withValues(alpha: 0.4),
                    color: widget.settingsService.accentColor,
                    minHeight: 6,
                  ),
                ),

                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                    },
                    children: [
                      _buildWelcomePage(),
                      _buildThemeAndLanguagePage(theme),
                      _buildAccentColorPage(theme),
                      _buildUnitsPage(theme),
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
                          child: TextButton.icon(
                            onPressed: () {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeInOutCubic,
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                            icon: const Icon(Icons.arrow_back_rounded),
                            label: const Text('Zurück'),
                          ),
                        ),
                      ),

                      FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: widget.settingsService.accentColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        ),
                        onPressed: () {
                          if (_currentPage < _totalSteps - 1) {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOutCubic,
                            );
                          } else {
                            widget.settingsService.completeOnboarding();
                          }
                        },
                        icon: Icon(_currentPage == _totalSteps - 1 ? Icons.check : Icons.arrow_forward_rounded),
                        label: Text(_currentPage == _totalSteps - 1 ? 'Starten' : 'Weiter'),
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
        Icon(Icons.wb_sunny_rounded, size: 72, color: widget.settingsService.accentColor),
        const SizedBox(height: 24),
        Text(
          'Simple Weather',
          style: theme.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'Dein minimalistischer Wetterbegleiter. Lass uns die App kurz an dich anpassen.',
          style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildThemeAndLanguagePage(ThemeData theme) {
    final service = widget.settingsService;
    return _buildCard(
      children: [
        Text('Erscheinungsbild', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        const Align(alignment: Alignment.centerLeft, child: Text('Sprache', style: TextStyle(fontWeight: FontWeight.bold))),
        const SizedBox(height: 8),
        SegmentedButton<String>(
          segments: const [
            ButtonSegment(value: 'de', label: Text('Deutsch'), icon: Icon(Icons.language)),
            ButtonSegment(value: 'en', label: Text('English'), icon: Icon(Icons.language)),
          ],
          selected: {service.language},
          onSelectionChanged: (newSelection) {
            service.updateLanguage(newSelection.first);
          },
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(service.themeMode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode),
                  const SizedBox(width: 12),
                  const Text('Dunkles Design', style: TextStyle(fontWeight: FontWeight.w500)),
                ],
              ),
              Switch(
                value: service.themeMode == ThemeMode.dark,
                activeThumbColor: service.accentColor,
                onChanged: (isDark) => service.updateThemeMode(isDark),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAccentColorPage(ThemeData theme) {
    final service = widget.settingsService;
    final List<Color> colors = [Colors.blue, Colors.green, Colors.orange, Colors.purple, Colors.red, Colors.teal];

    return _buildCard(
      children: [
        Text('Deine Akzentfarbe', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Text('Färbe Knöpfe und Details nach deinem Geschmack.', style: theme.textTheme.bodyMedium, textAlign: TextAlign.center),
        const SizedBox(height: 24),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: colors.map((color) {
            final isSelected = service.accentColor == color;
            return FilterChip(
              label: Container(width: 20, height: 20, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
              selected: isSelected,
              checkmarkColor: Colors.white,
              onSelected: (_) => service.updateAccentColor(color),
              selectedColor: color.withValues(alpha: 0.3),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
        Text('Einheitensystem', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Text('Wie sollen Temperaturen angezeigt werden?', style: theme.textTheme.bodyMedium, textAlign: TextAlign.center),
        const SizedBox(height: 24),
        SegmentedButton<String>(
          segments: const [
            ButtonSegment(value: 'metric', label: Text('Metrisch'), icon: Icon(Icons.thermostat)),
            ButtonSegment(value: 'imperial', label: Text('Imperial'), icon: Icon(Icons.thunderstorm)),
          ],
          selected: {service.units},
          onSelectionChanged: (newSelection) {
            service.updateUnits(newSelection.first);
          },
        ),
      ],
    );
  }
}
