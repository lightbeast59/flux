# Flux - Production-Ready Task Management App

**The world's best task management application built with Flutter**

## Architecture Overview

Flux is built with a clean, modular architecture using:
- **Flutter Web** - Cross-platform UI framework
- **Riverpod** - Robust state management with compile-time safety
- **Firebase** - Backend services (Authentication, Firestore, Hosting)
- **Material 3** - Modern, professional design system

## Project Structure

```
lib/
├── main.dart                           # App entry point
├── app.dart                            # App widget with auth wrapper
├── core/
│   ├── config/
│   │   └── firebase_config.dart        # Firebase initialization
│   ├── theme/
│   │   ├── app_theme.dart              # Material 3 theme configuration
│   │   └── app_colors.dart             # Custom color palette
│   └── widgets/
│       ├── loading_indicator.dart      # Reusable loading widgets
│       └── coming_soon_page.dart       # Placeholder for unfinished features
├── features/
│   ├── auth/                           # Authentication module
│   │   ├── data/
│   │   │   ├── models/user_model.dart
│   │   │   └── repositories/auth_repository.dart
│   │   ├── presentation/
│   │   │   ├── pages/login_page.dart
│   │   │   └── widgets/google_sign_in_button.dart
│   │   └── providers/auth_providers.dart
│   ├── calendar/                       # Calendar & tasks module
│   │   ├── data/
│   │   │   ├── models/task_model.dart
│   │   │   └── repositories/task_repository.dart
│   │   ├── presentation/
│   │   │   ├── pages/calendar_page.dart
│   │   │   └── widgets/
│   │   │       ├── calendar_grid.dart
│   │   │       ├── task_card.dart
│   │   │       └── task_creation_dialog.dart
│   │   └── providers/task_providers.dart
│   ├── dashboard/                      # Dashboard module
│   │   └── presentation/pages/dashboard_page.dart
│   └── [settings, profile, analytics]  # Other feature modules
└── shared/
    ├── widgets/
    │   ├── responsive_layout.dart      # Responsive breakpoints
    │   ├── app_sidebar.dart            # Desktop navigation
    │   └── app_bottom_bar.dart         # Mobile navigation
    └── navigation/
        └── home_wrapper.dart           # Main navigation wrapper
```

## Setup Instructions

### 1. Install Dependencies

```bash
flutter pub get
```

### 2. Configure Firebase

#### Option A: Using Firebase CLI (Recommended)

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Initialize FlutterFire
dart pub global activate flutterfire_cli
flutterfire configure
```

This will automatically create the Firebase configuration files.

#### Option B: Manual Configuration

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or select an existing one
3. Enable **Firebase Authentication** and add **Google Sign-In** provider
4. Enable **Cloud Firestore** in test mode (change rules later)
5. Register your web app and copy the config
6. Update `lib/core/config/firebase_config.dart`:

```dart
await Firebase.initializeApp(
  options: const FirebaseOptions(
    apiKey: 'YOUR_API_KEY',
    appId: 'YOUR_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    authDomain: 'YOUR_AUTH_DOMAIN',
    storageBucket: 'YOUR_STORAGE_BUCKET',
  ),
);
```

### 3. Firestore Security Rules

Go to Firebase Console > Firestore Database > Rules and add:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    match /tasks/{taskId} {
      allow read, write: if request.auth != null &&
                           request.auth.uid == resource.data.userId;
      allow create: if request.auth != null &&
                       request.auth.uid == request.resource.data.userId;
    }
  }
}
```

### 4. Run the App

```bash
# Development mode
flutter run -d chrome

# Build for production
flutter build web --release

# Test production build locally
flutter run -d web-server --web-port 8080 --release
```

## Key Features

### ✅ "Zero Dead-Ends" UI Policy
- Every navigation button is functional
- Unfinished features show a professional "Coming Soon" page
- No broken links or dead buttons

### ✅ Interactive Calendar
- Click any day to create a task for that specific date
- Color-coded priority dots on days with tasks
- Real-time updates across all tabs

### ✅ Advanced Task Management
- Smart creation dialog with date/time pickers
- Priority levels (High, Medium, Low)
- Complete CRUD operations
- Real-time sync with Firestore streams

### ✅ Web-Optimized Experience
- Hover effects on all interactive elements
- Responsive layout (sidebar on desktop, bottom bar on mobile)
- Smooth animations and transitions
- Material 3 design system

### ✅ Authentication
- Google Sign-In with proper web flow
- Session persistence across page refreshes
- User profile with photo and display name

## Production Deployment

### Deploy to Firebase Hosting

```bash
# Build production bundle
flutter build web --release

# Install Firebase CLI if not already installed
npm install -g firebase-tools

# Login to Firebase
firebase login

# Initialize hosting (select your project)
firebase init hosting

# When prompted:
# - Choose "public directory": build/web
# - Configure as single-page app: Yes
# - Set up automatic builds with GitHub: No (optional)

# Deploy
firebase deploy --only hosting
```

Your app will be live at: `https://YOUR_PROJECT_ID.web.app`

## Development Guidelines

### State Management
- Use Riverpod providers for all state
- Keep business logic in repositories
- Use `StreamProvider` for real-time data
- Use `FutureProvider` for one-time async operations

### Adding New Features

1. Create feature folder in `lib/features/[feature_name]/`
2. Follow the structure: `data/`, `presentation/`, `providers/`
3. Add navigation item in `app_sidebar.dart` and `app_bottom_bar.dart`
4. Add route in `home_wrapper.dart`

### Code Style
- Use `const` constructors wherever possible
- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Run `flutter analyze` before commits
- Use meaningful variable names

## Troubleshooting

### Firebase Auth Issues
- Ensure Google Sign-In is enabled in Firebase Console
- Add authorized domains in Authentication > Settings > Authorized domains
- For local testing, `localhost` is automatically authorized

### Firestore Permission Denied
- Check security rules in Firebase Console
- Ensure user is authenticated before accessing Firestore
- Verify `userId` matches authenticated user

### Build Issues
```bash
# Clean build cache
flutter clean

# Get dependencies
flutter pub get

# Regenerate generated files (if using code generation)
flutter pub run build_runner build --delete-conflicting-outputs
```

## Performance Optimization

- Use `const` widgets to reduce rebuilds
- Implement pagination for large task lists (future enhancement)
- Optimize Firestore queries with proper indexing
- Use `SelectableText` only where needed

## Future Enhancements

- [ ] Task categories and tags
- [ ] Recurring tasks
- [ ] Task sharing and collaboration
- [ ] Email notifications
- [ ] Dark mode toggle
- [ ] Task templates
- [ ] Export to PDF/CSV
- [ ] Mobile app (iOS/Android) using the same codebase

## License

This is a production-ready startup product. Handle accordingly.

## Support

For issues or questions:
1. Check this README
2. Review the code comments
3. Check Firebase Console for backend issues
4. Verify Flutter Web setup: `flutter doctor`

---

**Built with Flutter Web + Firebase + Riverpod**
**Designed for production, not tutorials.**
