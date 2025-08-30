# Flutter Template App

A comprehensive Flutter template application with Firebase integration, Google Sign-In, modern UI/UX, and production-grade architecture.

## ✨ Features

- **Multi-Platform Support**: iOS, Android, and Web
- **Firebase Integration**: Authentication, Firestore, and configuration
- **Google Sign-In**: Seamless authentication with Google accounts
- **Modern UI/UX**: Beautiful animations, gradients, and responsive design
- **Production Ready**: Comprehensive logging, error handling, and best practices
- **Environment Configuration**: Secure configuration using .env files
- **State Management**: Provider pattern for clean architecture
- **Template Cards**: Extensible card system for showcasing app features

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.9.0 or higher)
- Dart SDK
- Android Studio / Xcode (for mobile development)
- Firebase project
- Google Cloud Console project

### Installation

1. **Clone the repository**
   ```bash
   git clone <your-repo-url>
   cd my_template
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   
   a. Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
   
   b. Enable Authentication and Firestore
   
   c. Configure Google Sign-In:
      - Go to Authentication > Sign-in method
      - Enable Google Sign-in
      - Add your app's SHA-1 fingerprint (Android)
      - Configure OAuth consent screen (Google Cloud Console)
   
   d. Install FlutterFire CLI:
      ```bash
      dart pub global activate flutterfire_cli
      ```
   
   e. Configure FlutterFire:
      ```bash
      flutterfire configure
      ```

4. **Set up environment variables**
   
   Create a `.env` file in the root directory:
   ```env
   # Firebase Configuration
   FIREBASE_API_KEY=your_api_key_here
   FIREBASE_APP_ID=your_app_id_here
   FIREBASE_MESSAGING_SENDER_ID=your_sender_id_here
   FIREBASE_PROJECT_ID=your_project_id_here
   FIREBASE_STORAGE_BUCKET=your_storage_bucket_here
   
   # Google Sign-In Configuration
   GOOGLE_CLIENT_ID_ANDROID=your_android_client_id_here
   GOOGLE_CLIENT_ID_IOS=your_ios_client_id_here
   GOOGLE_CLIENT_ID_WEB=your_web_client_id_here
   
   # App Configuration
   APP_NAME=My Template App
   APP_VERSION=1.0.0
   ENVIRONMENT=development
   ```

5. **Platform-specific setup**

   **Android:**
   - Add SHA-1 fingerprint to Firebase project
   - Update `android/app/build.gradle.kts` with Google Services plugin
   
   **iOS:**
   - Add GoogleService-Info.plist to iOS project
   - Update URL schemes in Info.plist
   
   **Web:**
   - Configure authorized domains in Firebase Console

6. **Run the app**
   ```bash
   flutter run
   ```

## 🏗️ Architecture

```
lib/
├── core/                    # Core functionality
│   ├── config/             # App configuration
│   ├── error/              # Error handling
│   ├── logging/            # Logging framework
│   └── services/           # Core services
├── features/               # Feature modules
│   ├── auth/               # Authentication
│   └── landing/            # Landing page
└── shared/                 # Shared components
```

## 🔧 Configuration

### Firebase Configuration

The app uses Firebase for:
- User authentication
- Google Sign-In
- Cloud Firestore database
- Configuration management

### Environment Variables

All sensitive configuration is stored in `.env` files:
- Firebase API keys
- Google OAuth client IDs
- App configuration
- Environment-specific settings

### Logging

Production-grade logging with:
- Multiple log levels (debug, info, warning, error, fatal)
- Structured logging
- Performance optimization for production builds

## 🎨 Customization

### Template Cards

Add new feature cards by modifying the `templateCards` list in `landing_page.dart`:

```dart
final templateCards = [
  // ... existing cards
  {
    'title': 'Your Feature',
    'description': 'Description of your feature',
    'icon': Icons.your_icon,
    'color': Colors.your_color,
  },
];
```

### Styling

- **Colors**: Update the color scheme in `main.dart`
- **Fonts**: Modify Google Fonts in the theme
- **Animations**: Customize animation durations and curves

### Adding New Features

1. Create feature directory in `lib/features/`
2. Add providers for state management
3. Create UI components
4. Update routing if needed

## 📱 Platform Support

- **iOS**: Full support with native Google Sign-In
- **Android**: Full support with native Google Sign-In
- **Web**: Full support with web-optimized Google Sign-In

## 🚀 Deployment

### Production Build

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

### Environment Configuration

Update `.env` file for production:
```env
ENVIRONMENT=production
```

## 🔒 Security

- API keys stored in environment variables
- No hardcoded secrets
- Secure authentication flow
- Production-ready error handling

## 📚 Dependencies

Key packages used:
- `firebase_core`, `firebase_auth`, `cloud_firestore`
- `google_sign_in`
- `flutter_dotenv`
- `provider`
- `logger`
- `flutter_animate`
- `google_fonts`

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For support and questions:
- Create an issue in the repository
- Check the Firebase documentation
- Review Flutter documentation

## 🔄 Updates

Keep your template updated:
```bash
flutter pub upgrade
flutter clean
flutter pub get
```

---

**Happy coding! 🎉**
