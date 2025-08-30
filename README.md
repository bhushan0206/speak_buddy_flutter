# SpeakBuddy - AI-Powered Speech Therapy App

SpeakBuddy is a native mobile application addressing the critical gap in child-focused speech recognition technology. The app combines specialized AI speech recognition for children aged 2-12 with gamified learning experiences to create an effective and engaging speech therapy platform.

## 🌟 Key Value Propositions

- **Child-Specific AI**: Built exclusively for children's unique speech patterns and behaviors
- **Gamified Learning**: Story-driven adventures and interactive challenges
- **Professional Integration**: Seamless therapist-parent collaboration tools
- **Cultural Inclusivity**: Supports diverse accents, dialects, and languages
- **Privacy-First**: COPPA-compliant with local processing capabilities

## ✨ Features

- **AI Speech Recognition**: Specialized for children's speech patterns
- **Interactive Games**: Engaging speech therapy exercises
- **Progress Tracking**: Monitor speech development milestones
- **Parent Dashboard**: Track your child's progress
- **Therapist Portal**: Professional tools for speech therapists
- **Multi-Language Support**: Inclusive of diverse cultural backgrounds
- **Offline Capability**: Works without internet connection
- **Privacy Compliant**: COPPA and GDPR compliant

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
   cd speak_buddy
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
   APP_NAME=SpeakBuddy
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
│   ├── landing/            # Landing page
│   └── dashboard/          # User dashboard
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

### Feature Cards

Add new feature cards by modifying the `featureCards` list in `landing_page.dart`:

```dart
final featureCards = [
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

- **Colors**: Update the color scheme in `main.dart` for child-friendly themes
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

## 🔒 Security & Privacy

- API keys stored in environment variables
- No hardcoded secrets
- Secure authentication flow
- Production-ready error handling
- COPPA compliance for children's privacy
- Local data processing capabilities
- Secure data transmission

## 📚 Dependencies

Key packages used:
- `firebase_core`, `firebase_auth`, `cloud_firestore`
- `google_sign_in`
- `flutter_dotenv`
- `provider`
- `logger`
- `flutter_animate`
- `google_fonts`

## 🎯 Target Audience

- **Children aged 2-12** with speech development needs
- **Parents** seeking to support their child's speech development
- **Speech Therapists** looking for digital tools
- **Educators** supporting children with speech challenges

## 🌍 Accessibility & Inclusivity

- Support for multiple languages and accents
- Cultural sensitivity in design and content
- Accessibility features for children with different abilities
- Inclusive representation in app content

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

Keep your app updated:
```bash
flutter pub upgrade
flutter clean
flutter pub get
```

---

**Empowering children to find their voice! 🗣️✨**
