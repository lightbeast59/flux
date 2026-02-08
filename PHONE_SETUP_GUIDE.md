# Complete Phone Setup Guide for TaskNet

Your phone is not being detected by Flutter. Follow these steps carefully to fix the issue.

## Current Status
- ✅ Flutter is installed
- ✅ Android SDK is installed at: `C:\Users\Kkgam\AppData\Local\Android\sdk`
- ✅ Android Studio is installed
- ❌ Physical phone not detected (only emulator visible)

## Step-by-Step Fix

### Step 1: Enable USB Debugging on Your Phone

This is the MOST IMPORTANT step. Your phone won't connect without this.

1. **Open Settings** on your Android phone

2. **Enable Developer Options:**
   - Go to **Settings > About phone** (or "About device")
   - Find **Build number** (might be under "Software information")
   - **Tap it 7 times rapidly**
   - You'll see a message: "You are now a developer!"

3. **Enable USB Debugging:**
   - Go back to **Settings**
   - Find **System** (or "Additional settings")
   - Tap **Developer options**
   - Scroll down and find **USB debugging**
   - **Turn it ON**
   - Also enable **Install via USB** if available
   - If you see **USB debugging (Security settings)**, enable that too

### Step 2: Connect Your Phone Properly

1. **Use the RIGHT cable:**
   - Must be a **data cable** (not charging-only)
   - Use the original cable that came with your phone if possible

2. **Connect to PC:**
   - Plug USB cable into your phone
   - Plug other end into your PC's USB port
   - Try different USB ports if it doesn't work

3. **Select File Transfer Mode:**
   - When you connect, your phone will ask what to do
   - **Select "File Transfer"** or "Transfer files" or "MTP"
   - NOT "Charge only" or "Charge this device"

4. **Allow USB Debugging:**
   - A popup will appear on your phone: "Allow USB debugging?"
   - **Check "Always allow from this computer"**
   - Tap **OK** or **Allow**

### Step 3: Install Required Android Components

Run this command to ensure all Android SDK components are installed:

```cmd
flutter doctor --android-licenses
```

Type `y` and press Enter when prompted to accept each license.

### Step 4: Restart ADB Server

Run the fix script:
```cmd
fix_phone_connection.bat
```

This will restart the Android Debug Bridge (ADB) server and check for your device.

### Step 5: Verify Connection

After completing the above steps, check if your phone is detected:

```cmd
flutter devices
```

You should see something like:
```
Found 2 connected devices:
  SM G991B (mobile)  • 1234567890ABCDEF • android-arm64  • Android 14 (API 34)
  Windows (desktop)  • windows          • windows-x64    • Microsoft Windows
```

## Still Not Working? Try These:

### Option A: Restart Everything
1. Unplug your phone
2. Close all command prompts and Android Studio
3. Restart your phone
4. Restart your PC
5. Connect phone again and allow USB debugging
6. Run `fix_phone_connection.bat`

### Option B: Try Wireless Debugging (Android 11+)

If USB isn't working, you can connect wirelessly:

1. **On your phone:**
   - Developer Options > Wireless debugging > Turn ON
   - Tap "Pair device with pairing code"
   - Note the IP address and pairing code

2. **On your PC:**
   ```cmd
   adb pair <IP>:<PORT>
   ```
   Enter the pairing code when prompted

3. **Connect:**
   ```cmd
   adb connect <IP>:<PORT>
   ```

### Option C: Check USB Drivers

Your phone might need specific drivers:

1. Open **Device Manager** (search in Windows Start menu)
2. Look for your phone under "Portable Devices" or "Other devices"
3. If you see a yellow warning icon, right-click and select "Update driver"
4. Choose "Search automatically for drivers"

Or install **Google USB Driver**:
1. Open Android Studio
2. Go to **Tools > SDK Manager**
3. Click **SDK Tools** tab
4. Check **Google USB Driver**
5. Click **Apply**

### Option D: Use the Emulator Instead

If you can't get your phone working right now, you can test on the emulator:

```cmd
flutter emulators --launch Medium_Phone_API_36.1
flutter run
```

The emulator is already set up and working on your system.

## Quick Reference Commands

```cmd
# Check Flutter setup
flutter doctor -v

# List connected devices
flutter devices

# Fix ADB connection
fix_phone_connection.bat

# Run on specific device
flutter run -d <device-id>

# Run on emulator
flutter emulators --launch Medium_Phone_API_36.1
flutter run

# Clean build (if you have issues)
flutter clean
flutter pub get
flutter run
```

## Common Error Messages

| Error | Solution |
|-------|----------|
| "No devices found" | Enable USB debugging, check cable, restart ADB |
| "unauthorized" | Check phone for authorization popup, tap Allow |
| "offline" | Unplug and replug phone, restart ADB server |
| "device not found" | Wrong device ID, use `flutter devices` to get correct ID |

## Need More Help?

1. Run the diagnostic script: `check_mobile_setup.bat`
2. Check the full Flutter setup: `flutter doctor -v`
3. Read the official guide: https://docs.flutter.dev/get-started/install/windows/mobile

---

**After following these steps, your phone should be detected. Then you can run:**
```cmd
flutter run
```

The app will build and automatically install on your connected phone!
