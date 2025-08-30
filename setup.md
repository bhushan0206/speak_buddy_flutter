# Setup Guide for SpeakBuddy

## Quick Start

1. **Install Dependencies**
   ```bash
   flutter pub get
   ```

2. **Configure Firebase**
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Create a new project or use existing one
   - Enable Authentication and Firestore
   - Add your app (iOS/Android/Web)

3. **Set up Google Sign-In**
   - In Firebase Console, go to Authentication > Sign-in method
   - Enable Google Sign-in
   - Configure OAuth consent screen in Google Cloud Console

4. **Configure Environment Variables**
   - Copy `.env.example` to `.env`
   - Fill in your Firebase and Google configuration values

5. **Platform-specific Setup**

   **Android:**
   - Add SHA-1 fingerprint to Firebase project
   - Download `google-services.json` to `android/app/`

   **iOS:**
   - Download `GoogleService-Info.plist` to iOS project
   - Update URL schemes in `Info.plist`

   **Web:**
   - Configure authorized domains in Firebase Console

6. **Run the App**
   ```bash
   flutter run
   ```

## Troubleshooting

- **Dependencies not found**: Run `flutter clean && flutter pub get`
- **Firebase not initialized**: Check your `.env` file and Firebase configuration
- **Google Sign-In fails**: Verify OAuth client IDs and SHA-1 fingerprints
- **Build errors**: Ensure all platform-specific configurations are complete

## Next Steps

- Customize the feature cards in `landing_page.dart` to highlight speech therapy features
- Add speech recognition and therapy features in the `features/` directory
- Modify the theme and styling in `main.dart` for child-friendly design
- Implement speech therapy exercises and games
- Add progress tracking and reporting features

## Speech Therapy App Considerations

- **COPPA Compliance**: Ensure all features comply with children's privacy regulations
- **Accessibility**: Make the app accessible to children with different abilities
- **Cultural Sensitivity**: Include diverse representation and language support
- **Parent Controls**: Implement appropriate parental controls and monitoring
- **Offline Functionality**: Ensure core features work without internet connection

## Support

- Check the README.md for detailed documentation
- Review Firebase and Flutter documentation
- Create issues for bugs or feature requests
- Consider speech therapy professional consultation for app features
