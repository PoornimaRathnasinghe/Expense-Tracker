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

## Platform Support
This application is compatible with:
- Android
- iOS
- Web (via Firebase web support)

## Contributing

### How to Contribute
1. Fork the repository
2. Create a feature branch (git checkout -b feature/amazing-feature)
3. Commit your changes (git commit -m 'Add some amazing feature')
4. Push to the branch (git push origin feature/amazing-feature)
5. Open a Pull Request

### Code Style Guidelines

- Follow the Flutter style guide
- Use meaningful variable and function names
- Document your code with comments
- Write tests for new features
- Format your code with flutter format
- Analyze your code with flutter analyze

## Acknowledgements
- Firebase for backend services and authentication
- Flutter community for support and packages
- Provider for state management
- GetX for navigation and state management
- Google Sign-In for authentication
- Shared Preferences for local data storage
- Image Picker for media selection
- intl for internationalization and formatting
