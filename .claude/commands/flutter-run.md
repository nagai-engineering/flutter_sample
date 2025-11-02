---
description: Build, install, and run Flutter app on connected Android device
---

Build, install, and run the Flutter app on the connected Android device.

Follow these steps:

1. Check if the Android device is connected and authorized:
   - Run: `zsh -c 'source ~/.zshrc && adb devices'`
   - Verify that a device is listed with status "device" (not "unauthorized")
   - If unauthorized, ask the user to approve the USB debugging prompt on their device

2. Get Flutter dependencies (if not already done):
   - Run: `zsh -c 'source ~/.zshrc && flutter pub get'`

3. Build the debug APK:
   - Run: `zsh -c 'source ~/.zshrc && flutter build apk --debug'`
   - This may take several minutes on the first build
   - The APK will be created at: `build/app/outputs/flutter-apk/app-debug.apk`

4. Install the APK on the connected device:
   - Run: `zsh -c 'source ~/.zshrc && adb install -r build/app/outputs/flutter-apk/app-debug.apk'`
   - The `-r` flag reinstalls the app if it already exists

5. Launch the app on the device:
   - Run: `zsh -c 'source ~/.zshrc && adb shell am start -n com.example.flutter_sample/.MainActivity'`
   - Note: Replace `com.example.flutter_sample` with the actual package name from android/app/build.gradle if different

6. Inform the user to check their Android device screen to see the running app

**Important Notes:**
- All commands must be run with `zsh -c 'source ~/.zshrc && ...'` to ensure the Android SDK environment variables are loaded
- The device must remain connected via USB throughout the process
- If the build fails with Java errors, ensure Java JDK 17 is installed: `java -version`
