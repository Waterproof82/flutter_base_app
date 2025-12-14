#!/bin/bash
set -e

echo "Running flutter pub get..."
flutter pub get

echo "Building APK (release)..."
flutter build apk --release

echo "APK generated at: build/app/outputs/flutter-apk/app-release.apk"