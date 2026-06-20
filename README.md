# Simple Weather

<p align="center">
  <img src="https://img.shields.io/github/stars/OseMine/simple_weather?style=for-the-badge&logo=github&color=3182ce" alt="GitHub stars">
  <img src="https://img.shields.io/github/forks/OseMine/simple_weather?style=for-the-badge&logo=github&color=3182ce" alt="GitHub forks">
  <img src="https://img.shields.io/github/issues/OseMine/simple_weather?style=for-the-badge&logo=github&color=e53e3e" alt="GitHub issues">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter">
</p>



A minimalistic Flutter weather app that uses GPS location and OpenWeatherMap to display the current weather with a clean, animated interface.

## Overview

| | |
|---|---|
| **Platforms** | Android, iOS, macOS, Windows, Linux, Web |
| **Weather data** | [OpenWeatherMap](https://openweathermap.org/api) (free tier) |
| **Location** | GPS via `geolocator` |
| **State** | `ChangeNotifier` + `shared_preferences` |
| **Navigation** | Dual-axis `PageView` (vertical swipe + horizontal settings) |
| **Widgets** | Android home screen widget via `home_widget` |
| **Deployment** | GitHub Actions → APK, Web (Vercel) |

## Screenshots

<p align="center">
  <img src="assets/icons/screenshots/Weather%20Page.png" width="200" alt="Weather Page">
  <img src="assets/icons/screenshots/Details%20page.png" width="200" alt="Details Page">
</p>

## Features

- **GPS-based location** – uses `geolocator` with high accuracy for local weather
- **Current weather display** – temperature, description, and weather icon from OpenWeatherMap
- **Animated temperature** – count-up, slide-up, blur, and fade-in via `flutter_animate`
- **Shared weather background** – blurred weather icon watermark stays fixed behind all pages
- **Dual-axis navigation** – vertical swipe between Home and Forecast, horizontal to Settings
- **Forecast details** – temperature, condition, cloudiness, and wind speed
- **Metric / Imperial** – toggle between °C/m/s and °F/mph
- **Multi-language** – German and English with in-app switching
- **Accent color picker** – 7 preset colors + auto-detected system accent color
- **System accent color** – automatically picks up the device's default accent color
- **Dark mode** – manual or device-following theme
- **Pitch black mode** – true black for AMOLED displays
- **Custom gradient height & blur** – adjustable frosted-glass navigation bar
- **Onboarding flow** – 5-step first-launch wizard (requires location permission to proceed)
- **Home screen widget** – Android widget that updates with current weather
- **Persistent preferences** – all settings survive app restarts via `shared_preferences`
- **App reset** – restore all settings to device defaults (system theme + system accent)
- **Cross-platform** – Android, iOS, macOS, Windows, Linux, Web

## Tech Stack

| Layer       | Technology                        |
|-------------|-----------------------------------|
| Framework   | Flutter + Dart                    |
| HTTP        | `http` package                    |
| Geolocation | `geolocator`                      |
| Animations  | `flutter_animate`                 |
| Typography  | `google_fonts` (Roboto Flex)      |
| UI          | `soft_edge_blur`, `system_theme`  |
| API         | OpenWeatherMap (free tier)        |
| Widgets     | `home_widget`                     |
| Persistence | `shared_preferences`              |
| Icons       | `country_flags`                   |

## Project Structure

```
lib/
├── main.dart                          # App entry point, routing
├── screens/
│   ├── onboarding.dart                # 5-step first-launch wizard
│   ├── main_navigation.dart           # Dual-axis PageView + custom nav bar
│   ├── home_screen.dart               # Main weather display
│   ├── forecast_screen.dart           # Weather details (temp, wind, clouds)
│   ├── settings.dart                  # Settings page
│   └── settings/widgets/
│       ├── accent.dart                # Accent color picker bottom sheet
│       └── language.dart              # Language selector bottom sheet
├── services/
│   ├── getweather.dart                # Weather model + OpenWeatherMap fetch
│   ├── settings.dart                  # SettingsService (ChangeNotifier + prefs)
│   ├── api_key.dart                   # API key (gitignored)
│   ├── api_key_example.dart           # API key template
│   └── widget_service.dart            # Home widget update logic
└── widgets/
    ├── weather_background.dart        # Fixed blurred weather icon layer
    ├── temperature_display.dart       # Animated temperature counter
    └── slider_list_tile.dart          # Reusable slider tile widget

android/                               # Android platform files
ios/                                   # iOS platform files
macos/                                 # macOS platform files
macos-icons/                           # macOS app icon PNGs + .icns source
windows/                               # Windows platform files
linux/                                 # Linux platform files
web/                                   # Web platform files
assets/icons/                          # Adaptive icon SVGs + screenshots
```

## Installation & Setup

### Prerequisites

- Flutter SDK ^3.12.2
- OpenWeatherMap API key (free tier)

### Steps

1. Clone the repository:
   ```sh
   git clone https://github.com/OseMine/simple_weather.git
   cd simple_weather
   ```

2. Install dependencies:
   ```sh
   flutter pub get
   ```

3. Add your API key:
   ```sh
   cp lib/services/api_key_example.dart lib/services/api_key.dart
   ```
   Then edit `lib/services/api_key.dart` and replace `YOUR_API_KEY_HERE` with your actual OpenWeatherMap API key.

4. Run the app:
   ```sh
   flutter run
   ```

> **Note:** `lib/services/api_key.dart` is gitignored. The real key never leaves your machine unless you explicitly configure a CI secret.

## CI/CD

Three GitHub Actions workflows run on push/PR to `main`:

| Workflow | File | What it does |
|---|---|---|
| **Build APK** | `build-apk.yml` | analyze → test → build Android APK |
| **Build Web** | `build-web.yml` | analyze → test → build web → **deploy to Vercel** (main only) |
| **Release** | `release.yml` | on version bump: build APK + web → create GitHub Release |

### Setup Secrets

Go to **Settings → Secrets and variables → Actions** in your repo and add:

| Secret | Description |
|---|---|
| `OPENWEATHER_API_KEY` | Your OpenWeatherMap API key |
| `VERCEL_TOKEN` | Vercel API token (from Account → Settings → Tokens) |
| `VERCEL_ORG_ID` | Your Vercel team/username ID |
| `VERCEL_PROJECT_ID` | Your Vercel project ID |

Run `npx vercel link` locally to generate `.vercel/project.json` containing the org and project IDs.

### Triggering a Release

Bump the `version:` field in `pubspec.yaml` (e.g. `1.1.0+2`) and push to `main`. The release workflow detects the new version and creates a tagged release with APK + web ZIP.

## Apple Platform Notes

The app requires network access to fetch weather data from OpenWeatherMap. Entitlements are configured per platform:

| Platform | Entitlement File | Key |
|---|---|---|
| macOS Release | `macos/Runner/Release.entitlements` | `com.apple.security.network.client` |
| macOS Debug  | `macos/Runner/DebugProfile.entitlements` | `com.apple.security.network.client` |
| iOS          | `ios/Runner/Runner.entitlements` | `com.apple.security.network.client` |

macOS icons are maintained as individual PNGs in `macos-icons/` and automatically copied into the Xcode asset catalog.

## Android Platform Notes

### Permissions

Declared in `android/app/src/main/AndroidManifest.xml`:

| Permission | Purpose |
|---|---|
| `ACCESS_FINE_LOCATION` | GPS location for local weather |
| `ACCESS_COARSE_LOCATION` | Network-based fallback location |
| `INTERNET` | OpenWeatherMap API requests |

### Home Screen Widget

The app includes an Android home screen widget (`SimpleWeatherWidget`) registered via `android/app/src/main/res/xml/simple_weather_widget_info.xml`.

### Adaptive Icons

Launcher icons are configured in `pubspec.yaml` under `flutter_launcher_icons`:
- Foreground: `assets/icons/fg.svg`
- Background: `#FFFFFF`
- Monochrome: `assets/icons/fg.svg`

## TODOs

- [ ] Add hourly / daily extended forecast
- [ ] Add iOS build to CI
- [ ] Add more localizations (en/de already implemented)

## Contributing

1. Fork the repository.
2. Create a feature branch (`git checkout -b feature/your-feature`).
3. Commit your changes (`git commit -m 'Add your feature'`).
4. Push to the branch (`git push origin feature/your-feature`).
5. Open a Pull Request.

Please ensure `flutter analyze` passes and tests are updated.
