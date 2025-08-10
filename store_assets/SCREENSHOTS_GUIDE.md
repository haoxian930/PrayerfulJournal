# PrayerfulJournal Screenshots Guide

## How to Take App Screenshots for Google Play Store

### Option 1: Using Android Emulator (Recommended)

1. **Start Android Emulator:**
   ```bash
   # In VS Code terminal, run:
   flutter emulators --launch Pixel_7_API_35
   # (or whatever emulator you have)
   ```

2. **Run Your App:**
   ```bash
   flutter run
   ```

3. **Take Screenshots:**
   - Use the camera button in the emulator toolbar
   - Or press Ctrl+S in the emulator
   - Screenshots saved to: `%USERPROFILE%\AppData\Local\Android\Sdk\screenshots\`

### Option 2: Using Physical Android Device

1. **Enable Developer Options:**
   - Go to Settings > About Phone
   - Tap "Build Number" 7 times
   - Go back to Settings > Developer Options
   - Enable "USB Debugging"

2. **Connect Device & Run App:**
   ```bash
   flutter run
   ```

3. **Take Screenshots:**
   - Use ADB command: `adb shell screencap -p /sdcard/screenshot.png`
   - Or use device's built-in screenshot (Power + Volume Down)

### Screenshots Needed (in order):

1. **Home Screen** - Your prayer list/main interface
2. **Add Prayer Screen** - The form to add new prayers
3. **Prayer Detail Screen** - Viewing/editing a specific prayer
4. **Answered Prayers** - List of answered prayers with celebration
5. **Settings Screen** - App settings and preferences
6. **Notification Example** - If possible, show a prayer reminder

### Screenshot Best Practices:

- **Resolution:** Aim for 1080×1920 (9:16 ratio)
- **Content:** Show realistic prayer examples (avoid "Test" entries)
- **UI State:** Show the app in use, not empty states
- **Privacy:** Use example prayers that aren't too personal
- **Quality:** Clean, high-resolution images

### Example Prayer Content for Screenshots:

```
Prayer Title: "Healing for Mom"
Content: "Please heal my mother's back pain and give her strength during recovery."

Prayer Title: "Job Interview Success"
Content: "Guide me in tomorrow's interview and help me find the right opportunity."

Prayer Title: "Family Peace" (Answered)
Content: "Asking for harmony in our family during difficult times."
Answer: "We had a wonderful family dinner and resolved our differences!"
```

### Adding Device Frames (Optional but Professional):

1. **Visit MockUPhone.com**
2. **Upload your screenshots**
3. **Choose a modern Android device frame**
4. **Download framed versions**

### File Naming Convention:
- `01_home_screen.png`
- `02_add_prayer.png`
- `03_prayer_detail.png`
- `04_answered_prayers.png`
- `05_settings.png`
- `06_notification.png`

## Quick Commands for Screenshots:

```bash
# Start emulator
flutter emulators

# List available emulators
flutter emulators --launch <emulator_id>

# Run app
flutter run

# If using physical device, list connected devices
flutter devices

# Take screenshot via ADB (if using physical device)
adb shell screencap -p /sdcard/screenshot1.png
adb pull /sdcard/screenshot1.png ./store_assets/
```

Save all screenshots in the `store_assets` folder for easy upload to Google Play Console.
