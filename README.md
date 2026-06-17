# Simple Weather

A Flutter weather app that uses GPS location and OpenWeatherMap to display the current temperature with animated entrance effects.

## Features

- GPS-based location detection via `geolocator`
- Current temperature and weather description from OpenWeatherMap
- Animated temperature display: count-up, slide-up, blur, and fade-in
- Weather-condition background icon watermark
- Metric/imperial unit support
- Onboarding screen (placeholder)

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
   git clone https://github.com/YOUR_USERNAME/simple_weather.git
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

A GitHub Actions workflow (`.github/workflows/build.yml`) automatically builds on push/PR to `main`. To use it:

1. Go to **Settings → Secrets and variables → Actions** in your repo.
2. Add a repository secret named `OPENWEATHER_API_KEY` with your API key.
3. The workflow injects the key at build time via:
   ```sh
   echo "const String apiKey = '${{ secrets.OPENWEATHER_API_KEY }}';" > lib/services/api_key.dart
   ```

## Contributing

1. Fork the repository.
2. Create a feature branch (`git checkout -b feature/your-feature`).
3. Commit your changes (`git commit -m 'Add your feature'`).
4. Push to the branch (`git push origin feature/your-feature`).
5. Open a Pull Request.

Please ensure `flutter analyze` passes and tests are updated.
