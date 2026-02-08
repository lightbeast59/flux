@echo off
echo ========================================
echo TaskNest Firebase Setup Script
echo ========================================
echo.

echo Step 1: Logging into Firebase...
echo This will open your browser for sign-in.
echo.
firebase login
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Firebase login failed. Make sure Firebase CLI is installed.
    echo Run: npm install -g firebase-tools
    pause
    exit /b 1
)

echo.
echo ========================================
echo Step 2: Configuring FlutterFire...
echo ========================================
echo.
echo Please select your Firebase project and choose "Web" platform.
echo.

REM Try using flutterfire from PATH first, then try the full path
flutterfire configure
if %ERRORLEVEL% NEQ 0 (
    echo Trying alternate path...
    "%LOCALAPPDATA%\Pub\Cache\bin\flutterfire.bat" configure
)

if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] FlutterFire configuration failed.
    echo Make sure you:
    echo 1. Selected a Firebase project
    echo 2. Selected "Web" as the platform
    pause
    exit /b 1
)

echo.
echo ========================================
echo Step 3: Installing Flutter packages...
echo ========================================
flutter pub get

echo.
echo ========================================
echo Setup Complete!
echo ========================================
echo.
echo Next steps:
echo 1. Go to Firebase Console: https://console.firebase.google.com/
echo 2. Enable Google Sign-In in Authentication
echo 3. Create Firestore Database in test mode
echo 4. Add security rules (see SETUP_FIREBASE.md)
echo 5. Run: flutter run -d chrome
echo.
echo For detailed instructions, see SETUP_FIREBASE.md
echo.
pause
