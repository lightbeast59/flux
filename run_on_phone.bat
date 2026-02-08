@echo off
echo ========================================
echo TaskNet - Run on Mobile Phone
echo ========================================
echo.

echo Checking for connected devices...
flutter devices

echo.
echo ========================================
echo If your phone is listed above, press any key to run the app.
echo If not, please:
echo   1. Enable USB Debugging (see RUN_MOBILE.md)
echo   2. Connect your phone via USB
echo   3. Allow USB debugging on your phone
echo   4. Run this script again
echo ========================================
pause

echo.
echo Building and installing app on your phone...
echo This may take a few minutes on first run...
echo.

flutter run

echo.
echo ========================================
echo Done! Check your phone.
echo ========================================
pause
