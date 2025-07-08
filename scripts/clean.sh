#!/bin/bash

# Flutter Clean Automation Script for Unix/Linux/macOS
# Usage: ./scripts/clean.sh

echo "🧹 Starting Flutter Clean Process..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    print_error "Flutter is not installed or not in PATH"
    exit 1
fi

print_status "Flutter version:"
flutter --version

# Navigate to project root (assuming script is in scripts/ folder)
cd "$(dirname "$0")/.." || exit 1

print_status "Current directory: $(pwd)"

# Step 1: Flutter clean
print_status "Running flutter clean..."
if flutter clean; then
    print_success "Flutter clean completed"
else
    print_error "Flutter clean failed"
    exit 1
fi

# Step 2: Remove additional cache directories
print_status "Removing additional cache directories..."

# Remove .dart_tool
if [ -d ".dart_tool" ]; then
    rm -rf .dart_tool
    print_success "Removed .dart_tool directory"
fi

# Remove build directory
if [ -d "build" ]; then
    rm -rf build
    print_success "Removed build directory"
fi

# Remove iOS build cache
if [ -d "ios/build" ]; then
    rm -rf ios/build
    print_success "Removed iOS build cache"
fi

# Remove Android build cache
if [ -d "android/build" ]; then
    rm -rf android/build
    print_success "Removed Android build cache"
fi

if [ -d "android/app/build" ]; then
    rm -rf android/app/build
    print_success "Removed Android app build cache"
fi

# Remove generated files
print_status "Removing generated files..."
find . -name "*.g.dart" -type f -delete 2>/dev/null && print_success "Removed *.g.dart files"
find . -name "*.freezed.dart" -type f -delete 2>/dev/null && print_success "Removed *.freezed.dart files"

# Step 3: Get dependencies
print_status "Getting Flutter dependencies..."
if flutter pub get; then
    print_success "Dependencies downloaded successfully"
else
    print_error "Failed to get dependencies"
    exit 1
fi

# Step 4: Run build_runner (if build_runner is in pubspec.yaml)
if grep -q "build_runner" pubspec.yaml; then
    print_status "Running build_runner..."
    if flutter packages pub run build_runner build --delete-conflicting-outputs; then
        print_success "Build runner completed successfully"
    else
        print_warning "Build runner failed, but continuing..."
    fi
fi

# Step 5: Analyze code
print_status "Analyzing code..."
if flutter analyze; then
    print_success "Code analysis passed"
else
    print_warning "Code analysis found issues, but continuing..."
fi

print_success "🎉 Flutter clean process completed successfully!"
print_status "Your project is now clean and ready for development."