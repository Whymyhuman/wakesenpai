#!/bin/bash

# Deep Flutter Clean Script (comprehensive version)
# Usage: ./scripts/deep-clean.sh

echo "🔥 Deep Flutter Clean Process..."

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Check Flutter
if ! command -v flutter &> /dev/null; then
    print_error "Flutter not found"
    exit 1
fi

# Navigate to project root
cd "$(dirname "$0")/.." || exit 1

print_status "Starting deep clean process..."

# 1. Flutter clean
print_status "Running flutter clean..."
flutter clean

# 2. Remove all cache directories
print_status "Removing cache directories..."
rm -rf .dart_tool
rm -rf build
rm -rf .packages
rm -rf .flutter-plugins
rm -rf .flutter-plugins-dependencies

# 3. Remove platform-specific build caches
print_status "Removing platform build caches..."
rm -rf ios/build
rm -rf ios/.symlinks
rm -rf ios/Flutter/Flutter.framework
rm -rf ios/Flutter/Flutter.podspec
rm -rf ios/Pods
rm -rf ios/Podfile.lock

rm -rf android/build
rm -rf android/app/build
rm -rf android/.gradle

rm -rf macos/build
rm -rf macos/Flutter/ephemeral

rm -rf windows/build
rm -rf windows/flutter/ephemeral

rm -rf linux/build
rm -rf linux/flutter/ephemeral

rm -rf web/build

# 4. Remove generated files
print_status "Removing generated files..."
find . -name "*.g.dart" -type f -delete 2>/dev/null
find . -name "*.freezed.dart" -type f -delete 2>/dev/null
find . -name "*.mocks.dart" -type f -delete 2>/dev/null
find . -name "*.config.dart" -type f -delete 2>/dev/null

# 5. Clean pub cache (optional)
read -p "Do you want to clean pub cache? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_status "Cleaning pub cache..."
    flutter pub cache clean
fi

# 6. Get dependencies
print_status "Getting dependencies..."
flutter pub get

# 7. Run build_runner if exists
if grep -q "build_runner" pubspec.yaml; then
    print_status "Running build_runner..."
    flutter packages pub run build_runner build --delete-conflicting-outputs
fi

# 8. Upgrade dependencies (optional)
read -p "Do you want to upgrade dependencies? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_status "Upgrading dependencies..."
    flutter pub upgrade
fi

print_success "🎉 Deep clean completed successfully!"
print_status "Project is now completely clean and ready."