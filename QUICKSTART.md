# TaskNest - Quick Start Guide

Get your production-ready task management app running in 10 minutes.

## Prerequisites

- Flutter SDK (latest stable version)
- Chrome browser (for web testing)
- Firebase account (free tier is fine)
- Node.js (for Firebase CLI)

## Step-by-Step Setup

### 1. Install Dependencies (2 minutes)

```bash
flutter pub get
```

This will download all required packages including Firebase, Riverpod, and Material 3 components.

### 2. Configure Firebase (5 minutes)

#### Quick Setup with FlutterFire CLI (Recommended)

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase (this creates firebase_options.dart automatically)
flutterfire configure
```

When prompted:
1. Select or create a Firebase project
2. Select platforms: **Web** (we're building for web)
3. The CLI will automatically generate the configuration

#### Enable Firebase Services

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project

**Enable Authentication:**
- Go to Authentication > Sign-in method
- Enable **Google** provider
- Click Save

**Enable Firestore:**
- Go to Firestore Database
- Click "Create database"
- Start in **test mode** (we'll add security rules next)
- Choose a location close to your users

**Add Security Rules:**
- In Firestore Database > Rules tab, paste:

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

- Click **Publish**

### 3. Update Firebase Config (if using manual setup)

If you didn't use FlutterFire CLI, update `lib/core/config/firebase_config.dart`:

1. Go to Firebase Console > Project Settings > Your apps > Web app
2. Copy the Firebase configuration
3. Replace the placeholder values in `firebase_config.dart`

### 4. Run the App (1 minute)

```bash
# Run in Chrome
flutter run -d chrome

# Or run on a specific port
flutter run -d chrome --web-port 8080
```

The app will open in Chrome at `http://localhost:8080` (or the default port).

### 5. Test the App

1. Click **"Continue with Google"** on the login page
2. Sign in with your Google account
3. You'll be redirected to the Dashboard
4. Click **Calendar** in the sidebar
5. Click any day on the calendar to create a task
6. Fill in task details and click **Create**
7. Your task appears instantly with real-time sync

## What You Get Out of the Box

✅ **Google Sign-In** - Production-ready authentication
✅ **Interactive Calendar** - Click days to add tasks
✅ **Task Management** - Create, edit, delete, complete tasks
✅ **Real-time Sync** - Updates across all tabs instantly
✅ **Priority System** - High, Medium, Low priorities
✅ **Responsive Design** - Sidebar on desktop, bottom bar on mobile
✅ **Material 3 UI** - Modern, professional design
✅ **Hover Effects** - Smooth web interactions

## Development Tips

### Hot Reload
Press `r` in the terminal to hot reload changes while the app is running.

### Check for Errors
```bash
flutter analyze
```

### View Firestore Data
Go to Firebase Console > Firestore Database to see your tasks being created.

### Test on Different Screen Sizes
In Chrome DevTools (F12), use the responsive design mode to test mobile layout.

## Common Issues

### "Firebase not initialized"
- Make sure you ran `flutterfire configure`
- Check that `firebase_options.dart` exists
- Verify Firebase.initializeApp() is called in main.dart

### "Google Sign-In popup blocked"
- Allow popups for localhost in Chrome
- Check that Google provider is enabled in Firebase Console

### "Permission denied" in Firestore
- Verify security rules are published
- Make sure you're signed in
- Check that the userId in tasks matches your auth UID

### Port already in use
```bash
flutter run -d chrome --web-port 8081
```

## Next Steps

Once the app is running:

1. **Customize Colors**: Edit `lib/core/theme/app_colors.dart`
2. **Add Features**: Use the clean architecture to add new modules
3. **Deploy**: Follow the deployment guide in README.md
4. **Test**: Create multiple tasks, test priorities, test across tabs

## Deploy to Production

When ready to deploy:

```bash
# Build production bundle
flutter build web --release

# Deploy to Firebase Hosting
firebase init hosting
firebase deploy --only hosting
```

Your app will be live at `https://YOUR_PROJECT_ID.web.app`

## Support

Everything is configured to work out of the box. If you encounter issues:

1. Check this guide first
2. Verify Firebase setup in the console
3. Run `flutter doctor` to check your Flutter installation
4. Review the main README.md for detailed documentation

---

**You're ready to build the world's best task management app!**
