# Pyramidion Task — Home Categories UI

A Flutter app that recreates the "Shop by Categories" circular home UI with animations, API integration, offline caching, and accessibility support.

**Overview**
- Circular category layout with a central hub.
- Entrance animation where items pop out from the center with fade/scale and a connecting glow.
- Network images with placeholder and error handling.
- Responsive layout that adapts to different screen sizes.
- Offline caching and retry handling for network failures.
- Light/Dark theme support.
- Accessibility semantics for screen readers.

**Demo**
- Video: (https://drive.google.com/file/d/1b2eNcLCVaaHFVVRvwBAhTSDGg4tbLsPg/view?usp=sharing)

**Tools & Tech**
- Flutter (Dart)
- Provider (state management)
- HTTP (API calls)
- Cached Network Image (image caching/placeholder)
- Shared Preferences (offline cache)

**Requirements Checklist**
- [x] Circular layout with 9 category items around a central "Home" hub
- [x] Entrance animation (expands from center with fade/scale and glow)
- [x] Network image loading with proper placeholder/error handling
- [x] Tap interactions (ripple + selected state)
- [x] Responsive design across screen sizes
- [x] Loading and error states
- [x] Offline caching for categories
- [x] Basic unit tests for key components
- [x] Accessibility semantics
- [x] Dark/Light theme support

**Project Structure**
- `lib/presentation/` UI screens and widgets
- `lib/logic/` Providers and state handling
- `lib/data/` Models and repositories
- `lib/core/` Constants and utilities
- `test/` Unit and widget tests

**Setup**
1. Install Flutter SDK.
2. Fetch dependencies:
   ```
   flutter pub get
   ```
3. Run:
   ```
   flutter run
   ```

**API Configuration**
Update the endpoint in:
```
lib/core/constants/api_constants.dart
```

**Run Tests**
```
flutter test
```

**Build Release APK**
```
flutter build apk --release
```
Output:
```
build/app/outputs/flutter-apk/app-release.apk
```

**Android Permissions**
- `INTERNET` is required for API calls and image loading.
