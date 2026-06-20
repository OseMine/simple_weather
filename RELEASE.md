
# Simple Weather v1.2.0

A minimalist Flutter weather app with GPS-based location, animated UI, and OpenWeatherMap integration.

## Installation

Download the APK from the assets below and install it on your Android device. Make sure to allow installation from unknown sources in your settings.

### Web Version

A web build is also available as a ZIP – extract and serve with any static file server.

## Dev-Setup

1. Get a free API key at [OpenWeatherMap](https://openweathermap.org/api).
2. Create `lib/services/api_key.dart` with:
   ```dart
   const String apiKey = 'YOUR_API_KEY';
   ```
3. Launch the app and complete the one-time onboarding.

## What's Changed

### 🚀 New Features & Enhancements
- **Forecast Screen:** New dedicated details page with temperature, condition, cloudiness, and wind speed tiles.
- **Pitch Black Mode:** True black theme for AMOLED displays (available when dark mode is on).
- **System Accent Color:** Automatically detects and uses the device's default accent color; app reset restores to system defaults.
- **Device-Following Theme:** Onboarding and reset now respect the device's light/dark mode preference.
- **Shared Weather Background:** The blurred weather icon layer stays fixed behind all pages – no more jarring movement when swiping. **(Still In Progress. Might not work)**
- **Onboarding Location Lock:** The setup wizard now requires location permission to proceed.
- **Onboarding Redesign:** Restyled cards, accent picker, and navigation buttons to match the main app's visual language.
- **Settings Polish:** New accent color picker bottom sheet with AnimatedContainer, SwitchListTile for dark mode, FloatingActionButton.extended across all actions.
- **Singleton SettingsService:** Factory constructor ensures a single shared instance throughout the app.
- **Complete Finished Settings Screen**

### 🐛 Bug Fixes & Stability
- Fixed `implicit_this_reference_in_initializer` for accent color field initialization.
- Fixed `systemthemeMode` being uninitialized – now properly defaults to device brightness.
- Resolved weather background moving independently during page transitions. **(Might not Work)**
- Removed stale debug comments and unused imports across screens.
- General performance optimizations and code cleanup.

## Changelog

See the full commit history for details on every change in this release.
