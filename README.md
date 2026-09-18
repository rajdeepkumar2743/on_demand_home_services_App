# On-Demand Home Services App

A Flutter-based mobile application for booking and managing home services such as plumbing, cleaning, electrical work, painting, carpentry, gardening, and more. The project combines Firebase Authentication, Firestore, local SQLite storage, and state management via Provider to provide a practical service-booking experience.

## Project Analysis

After reviewing the codebase, this app is designed as a consumer-facing home services marketplace with the following core flows:

- User authentication with email/password, Google sign-in, and Microsoft sign-in
- Home dashboard with service cards and navigation
- Professional listing and service selection
- Booking creation and booking history
- Account and privacy settings
- Local SQLite sync and Firestore-backed data handling
- Connectivity-aware service synchronization

## Main Features

- Secure login and signup experience
- "Remember me" credential persistence using `flutter_secure_storage`
- Service catalog with pricing and descriptions
- Booking management for users
- Professional service listing
- Settings screens for account, privacy, security, notification, and help
- Firebase integration for authentication and cloud data
- Local database support for offline or local service persistence
- Provider-based state management across screens

## Tech Stack

- Flutter / Dart
- Firebase Core
- Firebase Authentication
- Cloud Firestore
- SQLite via `sqflite`
- Provider for state management
- Google Sign-In
- Connectivity checks with `connectivity_plus`
- Geolocation / location services
- UI support from Material Design and Lottie
- Toast notifications via `fluttertoast`

## App Architecture

The project follows a modular structure:

- `lib/main.dart` - app entry point, global providers, route setup, and auth redirect
- `lib/screens/` - screen-level UI such as login, home, bookings, settings, and profile management
- `lib/providers/` - state providers for services, bookings, user data, and settings
- `lib/models/` - domain models, such as `Service`
- `lib/service/` - Firebase and database service layer
- `lib/database/` - SQLite database helper for local storage
- `lib/widgets/` - reusable UI cards/components
- `assets/` - animation and image assets

## Core Code Insights

### Authentication
`lib/service/auth.dart` handles:

- email/password sign-in and sign-up
- Google sign-in
- Microsoft sign-in
- user session checking
- sign-out

The app checks authentication inside `AuthChecker` in `lib/main.dart` and routes users to either `HomeScreen` or `LoginScreen`.

### State Management
The app uses `Provider` to distribute app state globally:

- `UserProvider`
- `AccountSettingsProvider`
- `ServicesProvider`
- `ProfessionalsProvider`
- `BookingsProvider`
- `NotificationSettingsProvider`
- `PrivacySettingsProvider`

This keeps user/account and booking information consistent across multiple screens.

### Local + Cloud Data
The application merges cloud and local storage:

- `FirestoreService` fetches services from Firebase Firestore
- `DatabaseHelper` stores services and bookings in SQLite
- `HomeScreen` syncs Firestore data on app launch and on connectivity restoration

This design makes the app resilient and supports local caching.

### Navigation
`lib/main.dart` configures the app routes and uses:

- `MaterialApp.routes`
- `onGenerateRoute` for booking-specific arguments
- `Navigator.pushNamed` and `pushReplacement` for screen flow

## Project Structure

```text
on_demand_home_services/
├── android/
├── ios/
├── lib/
│   ├── database/
│   ├── models/
│   ├── providers/
│   ├── screens/
│   ├── service/
│   ├── widgets/
│   ├── api_service.dart
│   ├── forgot_password.dart
│   ├── home.dart
│   ├── main.dart
│   ├── numericpad.dart
│   ├── signup.dart
│   └── ...
├── assets/
├── test/
├── analysis_options.yaml
├── pubspec.yaml
├── README.md
├── .gitignore
├── android/app/google-services.json
└── ...
```

## Firebase Setup

This project uses Firebase services, so you need to configure Firebase for your own environment:

1. Create a Firebase project
2. Add Android and iOS apps as needed
3. Download the Firebase configuration files:
   - `google-services.json` for Android
   - `GoogleService-Info.plist` for iOS
4. Place them in the appropriate platform folders
5. Ensure Firebase is initialized in `main()` with `Firebase.initializeApp()`

## Installation and Run

### Prerequisites

- Flutter SDK installed
- Android Studio / Xcode for platform builds
- Firebase project configured

### Commands

```bash
flutter pub get
flutter run
```

For release builds:

```bash
flutter build apk
flutter build ios
```

## Usage Flow

1. Launch the app
2. Login or create a new account
3. View available services on the home screen
4. Select a service and book it
5. View booking history and status
6. Modify profile, notification, privacy, and security settings

## Notes and Observations

This is a functional prototype/starter app with solid structure for a home services marketplace. Some parts appear to be in active development, and there are a few patterns that may need cleanup for production quality, including:

- some duplicate or legacy screens/files (`home.dart`, `HomeScreen`, etc.)
- mixed local and remote data patterns
- repeated sync logic across app startup paths
- potential route naming inconsistencies

These are not blockers for a working app, but they are useful areas for refactoring before production release.

## Future Improvements

- Consolidate duplicate navigation flows
- Add admin panel for service management
- Add professional dashboard and booking approval workflow
- Implement order tracking and notifications
- Improve production-grade error handling and logging
- Add payment integration
- Add unit/widget tests for key workflows

## License

This project is currently unlicensed unless explicitly added later. If you are publishing or distributing it, consider adding a license such as MIT or Apache 2.0.

## Conclusion

This project is a solid Flutter on-demand home services app foundation with real-world features like login, service lists, Firebase integration, booking logic, and settings management. It is a good base for an MVP or service marketplace app and can be extended into a full production-ready platform.
