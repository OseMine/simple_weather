# Simple Weather

A Flutter weather app that uses GPS location and OpenWeatherMap to display the current temperature with animated entrance effects.

## Features

- GPS-based location detection via `geolocator`
- Current temperature and weather description from OpenWeatherMap
- Animated temperature display: count-up, slide-up, blur, and fade-in
- Weather-condition background icon watermark
- Metric/imperial unit support
- Onboarding screen (theme, accent color, units, language)

## Tech Stack

| Layer       | Technology                        |
|-------------|-----------------------------------|
| Framework   | Flutter + Dart                    |
| HTTP        | `http` package                    |
| Geolocation | `geolocator`                      |
| Animations  | `flutter_animate`                 |
| Typography  | `google_fonts` (Roboto Flex)      |
| API         | OpenWeatherMap (free tier)        |

## Project Structure

```
lib/
├── main.dart                          # App entry point
├── screens/
│   ├── home_screen.dart               # Main weather screen
│   └── onboarding.dart                # Onboarding (placeholder)
├── services/
│   ├── getweather.dart                # Weather model + API fetch
│   ├── settings.dart                  # App settings (units, etc.)
│   ├── api_key.dart                   # API key (gitignored)
│   └── api_key_example.dart           # API key template
└── widgets/
    ├── weather_background.dart        # Weather icon background layer
    └── temperature_display.dart       # Animated temperature counter
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

A GitHub Actions workflow (`.github/workflows/build.yml`) automatically builds on push/PR to `main`. It:

- Runs `flutter analyze` and `flutter test`
- Builds the web release
- Builds the Android APK release
- On push to `main`: detects version bumps in `pubspec.yaml` and creates a **GitHub Release** with the APK + web build using `RELEASE.md` as the body

### Setup

1. Go to **Settings → Secrets and variables → Actions** in your repo.
2. Add a repository secret named `OPENWEATHER_API_KEY` with your API key.
3. The workflow injects the key at build time via:
   ```sh
   echo "const String apiKey = '${{ secrets.OPENWEATHER_API_KEY }}';" > lib/services/api_key.dart
   ```

### Triggering a Release

Bump the `version:` field in `pubspec.yaml` (e.g. `1.1.0+2`) and push to `main`. The workflow will detect the new version and create a release automatically.

## TODOs

- [ ] Add weather icons matching the current condition (sun, rain, snow, etc.)
- [ ] Add hourly / daily forecast
- [ ] Settings screen for persisting preferences
- [ ] Add Android app signing for Play Store distribution
- [ ] Add iOS build to CI
- [ ] Add localization support (en/de already in settings service)

## Contributing

1. Fork the repository.
2. Create a feature branch (`git checkout -b feature/your-feature`).
3. Commit your changes (`git commit -m 'Add your feature'`).
4. Push to the branch (`git push origin feature/your-feature`).
5. Open a Pull Request.

Please ensure `flutter analyze` passes and tests are updated.
