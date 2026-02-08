# Running TaskNet on Your Mobile Phone

This guide will help you run the TaskNet app on your connected Android or iOS device.

## For Android Devices

### Step 1: Enable USB Debugging

1. **Enable Developer Options:**
   - Go to **Settings > About phone**
   - Find **Build number** and tap it **7 times**
   - You'll see a message saying "You are now a developer!"

2. **Enable USB Debugging:**
   - Go to **Settings > System > Developer options**
   - Enable **USB debugging**
   - Enable **Install via USB** (if available)

3. **Connect Your Phone:**
   - Connect your phone to your PC via USB cable
   - Select **File Transfer** or **MTP** mode (not just charging)
   - You should see a prompt on your phone asking to "Allow USB debugging" - tap **OK**
   - Check "Always allow from this computer" for convenience

### Step 2: Verify Connection

Open a terminal and run:
```bash
flutter devices
```

You should see your Android device listed. If not, try:
```bash
adb devices
```

If your device still doesn't show up:
- Try a different USB cable
- Try a different USB port
- Restart both your phone and PC
- Revoke USB debugging authorizations (Developer Options > Revoke USB debugging authorizations) and try again

### Step 3: Run the App

Once your device is detected, you can run the app in several ways:

**Option 1: Using Flutter Command**
```bash
flutter run
```

**Option 2: Using VS Code Launch Configuration**
- Press `F5` or go to Run > Start Debugging
- Select "TaskNet (Mobile Device)" from the dropdown
- The app will build and install on your phone

**Option 3: Specify Device Explicitly**
```bash
flutter run -d <device-id>
```

## For iOS Devices (Mac Required)

### Step 1: Trust Your Computer

1. Connect your iPhone/iPad to your Mac
2. Unlock your device
3. Tap **Trust** when prompted

### Step 2: Developer Account Setup

1. Open Xcode
2. Open the project: `ios/Runner.xcworkspace`
3. Select your device from the device list
4. Go to Signing & Capabilities
5. Select your Apple ID under Team

### Step 3: Run the App

```bash
flutter run
```

## Quick Commands

```bash
# List all connected devices
flutter devices

# Run on specific device
flutter run -d <device-id>

# Run in release mode (faster, optimized)
flutter run --release

# Run in profile mode (for performance testing)
flutter run --profile

# Clean build if you encounter issues
flutter clean
flutter pub get
flutter run
```

## Troubleshooting

### Android Device Not Detected

1. **Check USB Cable:** Use a data cable, not a charging-only cable
2. **Update Drivers:** Install/update Android USB drivers
3. **Check ADB:**
   ```bash
   adb kill-server
   adb start-server
   adb devices
   ```
4. **Wireless Debugging (Android 11+):**
   - Enable Wireless debugging in Developer Options
   - Run `adb pair` with the pairing code shown on phone

### Build Errors

If you get build errors:
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### Permission Denied

On Linux/Mac, you might need to set up udev rules for Android devices:
```bash
sudo usermod -aG plugdev $LOGNAME
```

## Performance Tips

- Use **Release mode** for final testing: `flutter run --release`
- Use **Profile mode** for performance analysis: `flutter run --profile`
- Debug mode is slower but provides hot reload capabilities

## Hot Reload

While the app is running on your device:
- Press `r` in the terminal to hot reload
- Press `R` for hot restart
- Press `q` to quit

Your app is now configured and ready to run on your mobile device!
