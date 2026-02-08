@echo off
echo ========================================
echo TaskNet - Mobile Setup Checker
echo ========================================
echo.

echo [1/6] Checking Flutter installation...
flutter --version
echo.

echo [2/6] Checking Flutter doctor...
flutter doctor
echo.

echo [3/6] Checking ADB and connected devices...
if exist "%LOCALAPPDATA%\Android\sdk\platform-tools\adb.exe" (
    set ADB_PATH=%LOCALAPPDATA%\Android\sdk\platform-tools\adb.exe
    echo ADB found at: %ADB_PATH%
    echo.
    echo Checking ADB devices:
    "%ADB_PATH%" devices -l
) else (
    echo WARNING: ADB not found at expected location
    echo Please install Android SDK Platform Tools via Android Studio
)
echo.

echo [4/6] Checking Flutter devices...
flutter devices
echo.

echo [5/6] Checking available emulators...
flutter emulators
echo.

echo [6/6] Checking Android licenses...
flutter doctor --android-licenses 2>NUL || echo Note: You may need to accept Android licenses.
echo.

echo ========================================
echo Setup Check Complete!
echo ========================================
echo.
echo PHONE CONNECTION STATUS:
echo   Look at the device lists above.
echo.
echo   If NO PHONE is detected:
echo      1. Read PHONE_SETUP_GUIDE.md (complete instructions)
echo      2. Enable USB Debugging on your phone
echo      3. Connect via USB cable (data cable, not charging-only)
echo      4. Allow USB debugging when prompted
echo      5. Run: fix_phone_connection.bat
echo.
echo   If PHONE IS DETECTED:
echo      Great! You can now run the app:
echo      - Option 1: run_on_phone.bat
echo      - Option 2: flutter run
echo.
echo   To use EMULATOR instead:
echo      flutter emulators --launch Medium_Phone_API_36.1
echo      flutter run
echo ========================================
pause
