# Quickstart: Flutter Mobile App for Happy Hour Discovery

**Branch**: `002-flutter-mobile-app` | **Date**: 2024-12-28

## Prerequisites

### Required Software

| Tool | Version | Installation |
|------|---------|--------------|
| Flutter SDK | ≥3.38.0 | [flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install) |
| Dart SDK | ≥3.8.0 | Included with Flutter |
| Android Studio | Latest | For Android development + emulator |
| Xcode | ≥15.0 | For iOS development (macOS only) |
| VS Code or Android Studio | Latest | IDE with Flutter plugin |

### Verify Installation

```bash
flutter doctor
```

All checks should pass for your target platforms (Android/iOS).

---

## Project Setup

### 1. Create Flutter Project

```bash
# From repository root
flutter create --org is.happyhour --project-name happyhour_app app

cd app
```

### 2. Add Dependencies

Update `app/pubspec.yaml`:

```yaml
name: happyhour_app
description: Find happy hour deals in Reykjavik
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.8.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  flutter_bloc: ^9.1.1
  equatable: ^2.0.7
  
  # Networking
  http: ^1.3.0
  
  # Location
  geolocator: ^14.0.0
  
  # Maps
  flutter_map: ^8.1.0
  latlong2: ^0.9.1
  
  # Routing
  go_router: ^15.1.0
  
  # JSON Serialization
  json_annotation: ^4.9.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
  
  # Testing
  bloc_test: ^10.0.0
  mocktail: ^1.0.5
  
  # Code Generation
  build_runner: ^2.4.15
  json_serializable: ^6.9.0

flutter:
  uses-material-design: true
```

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Generate Code (after creating models)

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## Project Structure

Create the Clean Architecture folder structure:

```bash
# From app/ directory
mkdir -p lib/presentation/screens
mkdir -p lib/presentation/widgets
mkdir -p lib/presentation/cubits
mkdir -p lib/application/use_cases
mkdir -p lib/domain/entities
mkdir -p lib/domain/repositories
mkdir -p lib/domain/value_objects
mkdir -p lib/infrastructure/api
mkdir -p lib/infrastructure/repositories
mkdir -p lib/infrastructure/dto
mkdir -p test/unit/cubits
mkdir -p test/unit/domain
mkdir -p test/unit/infrastructure
mkdir -p test/widget
```

Final structure:

```
app/
├── lib/
│   ├── main.dart
│   ├── presentation/
│   │   ├── screens/
│   │   │   ├── bars_list_screen.dart
│   │   │   └── bar_detail_screen.dart
│   │   ├── widgets/
│   │   │   ├── bar_list_item.dart
│   │   │   ├── filter_chip_bar.dart
│   │   │   ├── sort_dropdown.dart
│   │   │   └── error_banner.dart
│   │   └── cubits/
│   │       ├── bars_list_cubit.dart
│   │       ├── bars_list_state.dart
│   │       ├── bar_detail_cubit.dart
│   │       └── bar_detail_state.dart
│   ├── application/
│   │   └── use_cases/
│   │       ├── get_all_bars.dart
│   │       └── get_bar_by_id.dart
│   ├── domain/
│   │   ├── entities/
│   │   │   └── bar.dart
│   │   ├── repositories/
│   │   │   └── bar_repository.dart
│   │   └── value_objects/
│   │       ├── happy_hour_time.dart
│   │       └── happy_hour_days.dart
│   └── infrastructure/
│       ├── api/
│       │   └── bars_api_client.dart
│       ├── repositories/
│       │   └── bar_repository_impl.dart
│       └── dto/
│           └── bar_dto.dart
├── test/
│   ├── unit/
│   │   ├── cubits/
│   │   │   └── bars_list_cubit_test.dart
│   │   ├── domain/
│   │   │   └── happy_hour_time_test.dart
│   │   └── infrastructure/
│   │       └── bar_repository_impl_test.dart
│   └── widget/
│       └── bars_list_screen_test.dart
└── pubspec.yaml
```

---

## Platform Configuration

### Android

Update `app/android/app/src/main/AndroidManifest.xml`:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- Internet permission (required for API calls) -->
    <uses-permission android:name="android.permission.INTERNET"/>
    
    <!-- Location permissions (for distance sorting) -->
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
    
    <application
        android:label="Happy Hour"
        android:icon="@mipmap/ic_launcher">
        <!-- ... rest of application config ... -->
    </application>
</manifest>
```

### iOS

Update `app/ios/Runner/Info.plist`:

```xml
<dict>
    <!-- Location usage descriptions -->
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>We need your location to show bars near you and sort by distance.</string>
    <key>NSLocationAlwaysUsageDescription</key>
    <string>We need your location to show bars near you and sort by distance.</string>
    
    <!-- ... rest of plist ... -->
</dict>
```

---

## Running the App

### Development

```bash
cd app

# Run on connected device/emulator
flutter run

# Run on specific device
flutter devices  # List available devices
flutter run -d <device_id>

# Run with hot reload
flutter run  # Then press 'r' for hot reload, 'R' for restart
```

### Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/unit/domain/happy_hour_time_test.dart
```

### Building

```bash
# Build APK (Android)
flutter build apk --release

# Build App Bundle (Android - for Play Store)
flutter build appbundle --release

# Build iOS (macOS only)
flutter build ios --release
```

---

## API Endpoint

The app fetches data from:

```
https://ivarhuni.github.io/happyhour/data/bars.json
```

For local development, you can mock this endpoint or use a local JSON file.

---

## Common Commands

| Command | Description |
|---------|-------------|
| `flutter pub get` | Install dependencies |
| `flutter pub upgrade` | Upgrade dependencies |
| `dart run build_runner build` | Generate JSON serialization code |
| `flutter analyze` | Run static analysis |
| `flutter test` | Run tests |
| `flutter clean` | Clean build artifacts |

---

## Next Steps

1. Create domain entities (`Bar`, `HappyHourTime`, `HappyHourDays`)
2. Create DTO with JSON serialization
3. Implement repository interface and implementation
4. Create Cubits for state management
5. Build screens and widgets
6. Write tests

