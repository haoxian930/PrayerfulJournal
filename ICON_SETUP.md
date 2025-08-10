# Icon Generation Instructions

Since we cannot generate actual PNG files programmatically, you have a few options:

## Option 1: Use Flutter's Default Icons (Quickest)
Copy the default Flutter icons from any existing Flutter project:
- Look for `android/app/src/main/res/mipmap-*/ic_launcher.png` files
- Copy them to your project's corresponding directories

## Option 2: Online Icon Generator (Recommended)
1. Go to https://appicon.co/ or https://easyappicon.com/
2. Upload a 1024x1024 prayer-themed icon (hands praying, cross, etc.)
3. Download the Android icon pack
4. Extract and copy files to the mipmap directories

## Option 3: Android Studio Icon Generator
1. Open Android Studio
2. Right-click on `app` in Project view
3. New > Image Asset
4. Choose Icon Type: "Launcher Icons (Adaptive and Legacy)"
5. Design your icon
6. Click Next and Finish

## Option 4: Manual Creation
Create these PNG files and place them in the corresponding directories:

- `mipmap-mdpi/ic_launcher.png` (48x48)
- `mipmap-hdpi/ic_launcher.png` (72x72)
- `mipmap-xhdpi/ic_launcher.png` (96x96)
- `mipmap-xxhdpi/ic_launcher.png` (144x144)
- `mipmap-xxxhdpi/ic_launcher.png` (192x192)

For now, the app will use the adaptive icon defined in XML, which should work fine.

## Temporary Solution
If you want to test immediately, you can comment out the icon line in AndroidManifest.xml:
<!-- android:icon="@mipmap/ic_launcher" -->

This will use the default system icon for testing purposes.
