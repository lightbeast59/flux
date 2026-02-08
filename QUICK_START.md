# TaskNet - Quick Start Guide

## Phone Not Detected? Start Here!

### 1️⃣ First Time Setup (Do This Once)

**On Your Android Phone:**
1. Open **Settings** > **About phone**
2. Tap **Build number** 7 times (enables Developer mode)
3. Go back to **Settings** > **System** > **Developer options**
4. Enable **USB debugging**

**Connect Your Phone:**
1. Use a **data cable** (not charging-only)
2. Select **File Transfer** mode on your phone
3. Tap **Allow** when asked about USB debugging
4. Check "Always allow from this computer"

### 2️⃣ Fix Connection Issues

Run this script to restart ADB and check connection:
```cmd
fix_phone_connection.bat
```

### 3️⃣ Run the App

Once your phone is detected, run:
```cmd
flutter run
```

Or use the convenient script:
```cmd
run_on_phone.bat
```

---

## Alternative: Use Emulator

If you can't connect your phone right now, use the emulator:

```cmd
flutter emulators --launch Medium_Phone_API_36.1
flutter run
```

---

## Helpful Scripts

| Script | Purpose |
|--------|---------|
| `check_mobile_setup.bat` | Check if everything is set up correctly |
| `fix_phone_connection.bat` | Restart ADB and detect phone |
| `run_on_phone.bat` | Build and run app on phone |

---

## Common Issues

**"No devices found"**
- Enable USB debugging on phone
- Try different USB cable/port
- Run `fix_phone_connection.bat`

**"unauthorized"**
- Check phone for authorization popup
- Tap "Always allow" and "OK"

**Still having issues?**
- Read the complete guide: `PHONE_SETUP_GUIDE.md`
- Or run diagnostics: `check_mobile_setup.bat`

---

## After Your Phone is Connected

You can use these commands:

```cmd
# Run the app
flutter run

# Run in release mode (faster)
flutter run --release

# Hot reload (while app is running)
# Press 'r' in terminal

# Hot restart (while app is running)
# Press 'R' in terminal

# Quit (while app is running)
# Press 'q' in terminal
```

---

**Need more help?** Check `PHONE_SETUP_GUIDE.md` for detailed troubleshooting!
