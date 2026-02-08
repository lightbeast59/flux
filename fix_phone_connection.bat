@echo off
echo ========================================
echo TaskNet - Fix Phone Connection
echo ========================================
echo.

echo Step 1: Checking Android SDK location...
if exist "%LOCALAPPDATA%\Android\sdk\platform-tools\adb.exe" (
    set ADB_PATH=%LOCALAPPDATA%\Android\sdk\platform-tools\adb.exe
    echo Found ADB at: %ADB_PATH%
) else (
    echo ERROR: ADB not found!
    echo Please install Android SDK Platform Tools.
    echo.
    echo You can install them via Android Studio:
    echo   Tools ^> SDK Manager ^> SDK Tools ^> Android SDK Platform-Tools
    echo.
    pause
    exit /b 1
)

echo.
echo Step 2: Killing and restarting ADB server...
"%ADB_PATH%" kill-server
timeout /t 2 /nobreak >nul
"%ADB_PATH%" start-server
echo.

echo Step 3: Checking for connected devices...
"%ADB_PATH%" devices -l
echo.

echo ========================================
echo Device Detection Results:
echo ========================================
echo.
echo If you see "List of devices attached" with nothing below it:
echo   1. Make sure your phone is connected via USB
echo   2. On your phone, enable USB Debugging:
echo      - Settings ^> About phone
echo      - Tap "Build number" 7 times
echo      - Go back to Settings ^> System ^> Developer options
echo      - Enable "USB debugging"
echo   3. Select "File Transfer" or "MTP" mode on your phone
echo   4. Allow USB debugging when prompted on your phone
echo   5. Run this script again
echo.
echo If you see "unauthorized":
echo   - Check your phone for a USB debugging authorization popup
echo   - Tap "OK" or "Allow"
echo   - Check "Always allow from this computer"
echo.
echo If you see your device listed:
echo   - Great! Your phone is connected
echo   - Now you can run: flutter run
echo.
echo ========================================
pause
