# Expense Tracker App

A comprehensive mobile application built with Flutter for tracking personal finances, expenses, and income with robust features and Firebase integration.

## Features

### Authentication
- Email and password login/registration
- Google Sign-In integration
- Password recovery functionality
- Secure authentication via Firebase Auth

### Financial Management
- Add, edit, and delete transactions
- Categorize expenses and income
- Track spending patterns over time
- Filter transactions by date, category, or amount

### Analytics & Insights
- Visual representation of spending habits
- Monthly and yearly financial summaries
- Budget tracking and alerts
- Expense distribution by category

### User Experience
- Dark/Light theme toggle
- Persistent theme preferences
- Intuitive navigation interface
- Responsive design for various screen sizes

## Technical Implementation

### Frontend
- Built with Flutter for cross-platform compatibility
- State management using Provider and GetX
- Responsive UI with Material Design components
- Shared Preferences for local data persistence

### Backend
- Firebase Authentication for user management
- Cloud Firestore for transaction data storage
- Real-time data synchronization
- Secure data access rules

## Dependencies

This application uses the following key packages:
- **Firebase Suite**:
  - firebase_core: ^3.9.0
  - cloud_firestore: ^5.6.1
  - firebase_auth: ^5.4.1
  - firebase_storage: ^12.4.1
- **State Management**:
  - provider: ^6.1.2
  - get: ^4.6.6
- **Authentication**:
  - google_sign_in: ^6.2.2
- **Storage**:
  - shared_preferences: ^2.3.3
- **Media**:
  - image_picker: ^1.1.2
- **Utilities**:
  - intl: 0.19.0
  - rxdart: ^0.27.6
  - permission_handler: ^10.0.0

## Getting Started

### Prerequisites
- Flutter SDK (>= 3.4.3)
- Dart SDK (>= 3.4.3)
- Firebase project setup
- Android Studio / VS Code with Flutter plugins

### Installation
1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Connect your Firebase project (follow Firebase Flutter integration guide)
4. Update `firebase_options.dart` with your project configurations
5. Run `flutter run` to launch the app

### Configuration
- Update `firebase_options.dart` with your Firebase project details
- Configure Google Sign-In credentials in Firebase console
- Set up Firestore database rules for secure access

## Firebase Setup

For security reasons, Firebase configuration files are not included in this repository.

### Setup Steps:

1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Register your app and download configuration files:
   - For Android: Place `google-services.json` in `android/app/`
   - For iOS: Place `GoogleService-Info.plist` in `ios/Runner/`
3. Create `lib/firebase_options.dart` based on the template

### Firebase Configuration Template

Create a file called `firebase_options_template.dart` in your repository with placeholders instead of actual credentials. Developers can copy this file to `firebase_options.dart` and fill in their own values:

```dart
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // Replace these placeholder values with your own Firebase configuration
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'YOUR_WEB_API_KEY',
    appId: 'YOUR_WEB_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    authDomain: 'YOUR_AUTH_DOMAIN',
    storageBucket: 'YOUR_STORAGE_BUCKET',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR_ANDROID_API_KEY',
    appId: 'YOUR_ANDROID_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_STORAGE_BUCKET',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    appId: 'YOUR_IOS_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_STORAGE_BUCKET',
    iosClientId: 'YOUR_IOS_CLIENT_ID',
    iosBundleId: 'YOUR_IOS_BUNDLE_ID',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'YOUR_MACOS_API_KEY',
    appId: 'YOUR_MACOS_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_STORAGE_BUCKET',
    iosClientId: 'YOUR_MACOS_CLIENT_ID',
    iosBundleId: 'YOUR_MACOS_BUNDLE_ID',
  );
}
```

### Securing API Keys

For additional security:

1. Add the following files to your `.gitignore`:
```
# Firebase configuration
google-services.json
GoogleService-Info.plist
lib/firebase_options.dart
.env
```

2. Create a `.env` file to store sensitive information:
```
ANDROID_API_KEY=your_api_key_here
IOS_API_KEY=your_api_key_here
WEB_API_KEY=your_api_key_here
```

3. Load environment variables in your app:
```dart
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
```

### Firebase App Check

Consider implementing Firebase App Check for additional security:
1. Add the dependency: `firebase_app_check: ^latest_version` 
2. Initialize App Check before Firebase:
```dart
await FirebaseAppCheck.instance.activate(
  webRecaptchaSiteKey: 'your_recaptcha_key',
);
```

## Platform Support
This application is compatible with:
- Android
- iOS
- Web (via Firebase web support)

## Contributing

### How to Contribute
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Style Guidelines
- Follow the [Flutter style guide](https://github.com/flutter/flutter/wiki/Style-guide-for-Flutter-repo)
- Use meaningful variable and function names
- Document your code with comments
- Write tests for new features
- Format your code with `flutter format .`
- Analyze your code with `flutter analyze`

## Acknowledgements
- [Firebase](https://firebase.google.com/) for backend services and authentication
- [Flutter](https://flutter.dev/) community for support and packages
- [Provider](https://pub.dev/packages/provider) for state management
- [GetX](https://pub.dev/packages/get) for navigation and state management
- [Google Sign-In](https://pub.dev/packages/google_sign_in) for authentication
- [Shared Preferences](https://pub.dev/packages/shared_preferences) for local data storage
- [Image Picker](https://pub.dev/packages/image_picker) for media selection
- [intl](https://pub.dev/packages/intl) for internationalization and formatting
