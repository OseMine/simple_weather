# Simple Weather

A Flutter weather app that uses GPS location and OpenWeatherMap to display the current temperature with animated entrance effects.

## Features

- GPS-based location detection via `geolocator`
- Current temperature and weather description from OpenWeatherMap
- Animated temperature display: count-up, slide-up, blur, and fade-in
- Weather-condition background icon watermark
- Metric/imperial unit support
- Onboarding screen (theme, accent color, units, language)
- Settings screen with persistent preferences
- Home screen widget (Android/iOS)
- Cross-platform: Android, (iOS, macOS), Windows, Linux, Web

## Tech Stack

| Layer       | Technology                        |
|-------------|-----------------------------------|
| Framework   | Flutter + Dart                    |
| HTTP        | `http` package                    |
| Geolocation | `geolocator`                      |
| Animations  | `flutter_animate`                 |
| Typography  | `google_fonts` (Roboto Flex)      |
| API         | OpenWeatherMap (free tier)        |
| Widgets     | `home_widget`                     |
| Persistence | `shared_preferences`              |

## Project Structure

```
lib/
├── main.dart                          # App entry point
├── screens/
│   ├── home_screen.dart               # Main weather screen
│   ├── onboarding.dart                # First-launch setup
│   └── settings.dart                  # Preferences (units, theme, etc.)
├── services/
│   ├── getweather.dart                # Weather model + API fetch
│   ├── settings.dart                  # App settings (units, etc.)
│   ├── api_key.dart                   # API key (gitignored)
│   ├── api_key_example.dart           # API key template
│   └── widget_service.dart            # Home widget update logic
└── widgets/
    ├── weather_background.dart        # Weather icon background layer
    └── temperature_display.dart       # Animated temperature counter

android/                               # Android platform files
ios/                                   # iOS platform files
macos/                                 # macOS platform files
macos-icons/                           # macOS app icon PNGs + .icns source
windows/                               # Windows platform files
linux/                                 # Linux platform files
web/                                   # Web platform files
assets/icons/                          # Adaptive icon SVGs
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

- [ ] Add hourly / daily forecast
- [ ] Add iOS build to CI
- [ ] Add localization support (en/de already in settings service)

## Contributing

1. Fork the repository.
2. Create a feature branch (`git checkout -b feature/your-feature`).
3. Commit your changes (`git commit -m 'Add your feature'`).
4. Push to the branch (`git push origin feature/your-feature`).
5. Open a Pull Request.

Please ensure `flutter analyze` passes and tests are updated.
