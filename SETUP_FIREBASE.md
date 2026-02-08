# Firebase Setup Guide for TaskNest

Follow these steps **in order** to set up Firebase for your TaskNest app.

## Step 1: Login to Firebase (Required First)

Open a **new terminal/command prompt** in this project directory and run:

```bash
firebase login
```

- This will open your browser
- Sign in with your Google account
- Allow Firebase CLI access

## Step 2: Configure FlutterFire

After logging in, run:

```bash
flutterfire configure
```

**You'll be prompted with:**

### Q: Select a Firebase project
- **Option 1:** Select an existing project (if you have one)
- **Option 2:** Create a new project (recommended)
  - Choose a name like `tasknest` or `tasknest-web`

### Q: Which platforms should your configuration support?
- Use arrow keys and **spacebar** to select
- **Select ONLY: Web** (press spacebar to check it)
- Press Enter to confirm

### What happens:
✅ Creates `lib/firebase_options.dart` (auto-generated config)
✅ Creates `.firebaserc` (project settings)
✅ Sets up your app in Firebase Console

## Step 3: Enable Firebase Services in Console

Go to [Firebase Console](https://console.firebase.google.com/)

### A. Enable Authentication

1. Click on your project (tasknest)
2. Go to **Build** → **Authentication**
3. Click **Get Started**
4. Click on **Sign-in method** tab
5. Click **Google** provider
6. **Enable** it
7. Select a support email
8. Click **Save**

### B. Enable Firestore Database

1. Go to **Build** → **Firestore Database**
2. Click **Create database**
3. Select **Start in test mode** (we'll add security rules later)
4. Choose a location close to you (e.g., us-central, europe-west)
5. Click **Enable**

### C. Add Security Rules (Important!)

1. In Firestore Database, click on **Rules** tab
2. Replace all content with this:

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

3. Click **Publish**

## Step 4: Verify Setup

Run these commands to verify everything is set up:

```bash
# Check if firebase_options.dart was created
ls lib/firebase_options.dart

# Check Flutter configuration
flutter doctor
```

## Step 5: Run the App

```bash
flutter run -d chrome
```

If Chrome is not available, you can use:
```bash
flutter run -d edge
```

## Troubleshooting

### "firebase: command not found"
The Firebase CLI path isn't in your system PATH. Add it:
- Windows: Add to PATH environment variable
- Or reinstall: `npm install -g firebase-tools`

### "flutterfire: command not found"
The Dart pub cache isn't in your PATH:
- Windows: Add `C:\Users\<YourUsername>\AppData\Local\Pub\Cache\bin` to PATH
- Or use full path: `C:\Users\Kkgam\AppData\Local\Pub\Cache\bin\flutterfire configure`

### "Permission denied" error in app
- Make sure you published the Firestore security rules
- Verify you're signed in with Google in the app

### "Google Sign-In popup blocked"
- Allow popups for localhost in your browser settings
- Try in incognito/private mode

## What You Should See

After completing setup:

1. **App opens in Chrome**
2. **Login page** with "Continue with Google" button
3. **Click button** → Google sign-in popup
4. **After signing in** → Dashboard page
5. **Click Calendar** → Interactive calendar
6. **Click any day** → Create task dialog

## Quick Reference Commands

```bash
# Login to Firebase
firebase login

# Configure FlutterFire
flutterfire configure

# Install dependencies
flutter pub get

# Run app
flutter run -d chrome

# Build for production
flutter build web --release
```

## Next Steps After Setup

Once the app is running:
- ✅ Test Google Sign-In
- ✅ Create a task
- ✅ Check Firestore in Firebase Console to see data
- ✅ Test on different screen sizes (resize browser)
- ✅ Customize colors in `lib/core/theme/app_colors.dart`

---

**Need help?** Check QUICKSTART.md for more detailed explanations.
